class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    # Définir les utilisateurs à afficher en fonction du rôle actuel (family ou au pair)
    @users = current_user.family? ? User.aupair : User.family

    # Récupérer les bornes min et max du nombre d'enfants parmi les utilisateurs family
    @min_children = User.family.minimum(:number_of_children)
    @max_children = User.family.maximum(:number_of_children)

    # Calculer la durée maximale (en jours) pour les availabilities
    @max_duration = Availability.maximum("availabilities.end - availabilities.start").to_i if Availability.any?

    # Récupérer la date de début minimale et maximale parmi les au pairs
    if current_user.family?
      @earliest_start_date = Availability.joins(:user).where(users: { role: 'aupair' }).minimum(:start)
      @latest_start_date = Availability.joins(:user).where(users: { role: 'aupair' }).maximum(:start)
    end

    # Application des filtres
    apply_filters if params[:filters].present?
  end

  def show
    @visited_user = User.find(params[:id])

    # Vérifier la présence des coordonnées dans le profil utilisateur
    @map = [{ lat: @visited_user.latitude, lng: @visited_user.longitude }] if @visited_user.geocoded?
  end

  def edit
    @user = current_user
  end

  def update
  end

  private

  def apply_filters
    Rails.logger.info "Params de filtres : #{params[:filters]}"

    # Filtrer par nationalité (au pairs ou familles)
    if params[:filters][:nationality].present? && params[:filters][:nationality].reject(&:blank?).any?
      @users = @users.where(nationality: params[:filters][:nationality])
    end

    # Filtrer par genre (uniquement pour les familles cherchant des au pairs)
    if current_user.family? && params[:filters][:gender].present? && params[:filters][:gender] != "All genders"
      Rails.logger.info "Filtre de genre appliqué : #{params[:filters][:gender]}"
      @users = @users.where(gender: params[:filters][:gender])
    end

    # Filtrer par nombre d'enfants maximum (si au pair recherchant des familles)
    if current_user.aupair? && params[:filters][:max_number_of_children].present?
      Rails.logger.info "Filtre nombre d'enfants max appliqué : #{params[:filters][:max_number_of_children]}"
      @users = @users.where("number_of_children <= ?", params[:filters][:max_number_of_children].to_i)
    end

    # Filtrer par langues parlées
    if current_user.family? && params[:filters][:languages].present? && params[:filters][:languages].reject(&:blank?).any?
      selected_languages = params[:filters][:languages].reject(&:blank?)
      Rails.logger.info "Filtre de langues appliqué : #{selected_languages}"
      language_ids = Language.where(language: selected_languages).pluck(:id)
      @users = @users.joins(:languages).where(languages: { id: language_ids }).distinct
    end

    # Filtrer par plage de dates de disponibilité
    start_min = params[:filters][:start_date_min].present? ? Date.parse(params[:filters][:start_date_min]) : @earliest_start_date
    start_max = params[:filters][:start_date_max].present? ? Date.parse(params[:filters][:start_date_max]) : @latest_start_date
    if current_user.family? && start_min && start_max
      Rails.logger.info "Filtre sur dates appliqué : de #{start_min} à #{start_max}"
      @users = @users.joins(:availabilities).where(availabilities: { start: start_min..start_max }).distinct
    end

    # Filtrer par durée du séjour
    if current_user.family?
      min_duration = params[:filters][:min_duration].present? ? params[:filters][:min_duration].to_i : 1
      max_duration = params[:filters][:max_duration].present? ? params[:filters][:max_duration].to_i : @max_duration
      Rails.logger.info "Filtre sur durée appliqué : entre #{min_duration} et #{max_duration} jours"
      if min_duration > 0 && max_duration > min_duration
        @users = @users.joins(:availabilities)
                       .where("availabilities.end - availabilities.start BETWEEN ? AND ?", min_duration, max_duration).distinct
      else
        Rails.logger.info "Durée incorrecte : min_duration=#{min_duration}, max_duration=#{max_duration}"
      end
    end
  end
end
