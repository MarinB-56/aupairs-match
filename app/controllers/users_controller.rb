class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :remove_availability, :add_language, :remove_language]
  before_action :set_nationalities, only: [:edit, :update]
  before_action :set_languages, only: [:edit, :update]

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

    # Définir les valeurs par défaut pour les filtres
    @default_filters = {
      nationality: nil,
      max_number_of_children: @max_children,
      gender: nil,
      languages: nil,
      start_date_min: @earliest_start_date,
      start_date_max: @latest_start_date,
      min_duration: 1,
      max_duration: @max_duration
    }

    # Sauvegarde des paramètres filtrés pour la vue
    @filtered_params = filters_params

    # Application des filtres
    apply_filters if @filtered_params.present?
  end

  def show
    @visited_user = User.find(params[:id])

    # Vérifier la présence des coordonnées dans le profil utilisateur
    @map = [{ lat: @visited_user.latitude, lng: @visited_user.longitude }] if @visited_user.geocoded?
  end

  def edit
    @user = current_user
    @user.availabilities.build if @user.availabilities.empty?
  end

  def update
    if @user.update(user_params)
      redirect_to edit_user_path(@user), notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  def update_profile_picture
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = "Profile picture updated successfully!"
      redirect_to edit_user_path(@user)
    else
      flash[:error] = "There was a problem updating your profile picture."
      render :edit
    end
  end

  def remove_availability
    availability = @user.availabilities.find(params[:availability_id])
    availability.destroy
    redirect_to edit_user_path(@user), notice: 'Availability removed successfully.'
  end

  def add_language
    language = Language.find_or_create_by(language: params[:language_id])
    if @user.languages.exclude?(language)
      @user.languages << language
      flash[:notice] = "Language added successfully."
    else
      flash[:alert] = "Language already added."
    end
    redirect_to edit_user_path(@user)
  end

  def remove_language
    language = Language.find(params[:language_id])
    @user.languages.delete(language)
    redirect_to edit_user_path(@user), notice: 'Language removed successfully'
  end

  private

  def apply_filters
    # Utilisation de filters_params au lieu de params[:filters]
    filter_params = filters_params

    # Filtrer par nationalité
    if filter_params[:nationality].present? && filter_params[:nationality].reject(&:blank?).any?
      @users = @users.where(nationality: filter_params[:nationality])
    end

    # Filtrer par genre (pour les familles recherchant des au pairs)
    if current_user.family? && filter_params[:gender].present? && filter_params[:gender] != "All genders"
      @users = @users.where(gender: filter_params[:gender])
    end

    # Filtrer par nombre d'enfants (pour les au pairs recherchant des familles)
    if current_user.aupair? && filter_params[:max_number_of_children].present?
      @users = @users.where("number_of_children <= ?", filter_params[:max_number_of_children].to_i)
    end

    # Filtrer par langues parlées
    if current_user.family? && filter_params[:languages].present? && filter_params[:languages].reject(&:blank?).any?
      selected_languages = filter_params[:languages].reject(&:blank?)
      language_ids = Language.where(language: selected_languages).pluck(:id)
      @users = @users.joins(:languages).where(languages: { id: language_ids }).distinct
    end

    # Filtrer par plage de dates
    start_min = filter_params[:start_date_min].present? ? Date.parse(filter_params[:start_date_min]) : @earliest_start_date
    start_max = filter_params[:start_date_max].present? ? Date.parse(filter_params[:start_date_max]) : @latest_start_date
    if current_user.family? && start_min && start_max
      @users = @users.joins(:availabilities).where(availabilities: { start: start_min..start_max }).distinct
    end

    # Filtrer par durée du séjour
    if current_user.family?
      min_duration = filter_params[:min_duration].present? ? filter_params[:min_duration].to_i : 1
      max_duration = filter_params[:max_duration].present? ? filter_params[:max_duration].to_i : @max_duration
      if min_duration > 0 && max_duration > min_duration
        @users = @users.joins(:availabilities)
                       .where("availabilities.end - availabilities.start BETWEEN ? AND ?", min_duration, max_duration).distinct
      end
    end
  end

  def filters_params
    params.fetch(:filters, {}).permit(
      { nationality: [] },
      { languages: [] },
      :gender,
      :max_number_of_children,
      :min_duration,
      :max_duration,
      :start_date_min,
      :start_date_max
    )
  end

  def set_nationalities
    @nationalities = YAML.load_file(Rails.root.join('config/nationalities.yml'))['nationalities']
  end

  def set_languages
    @languages = YAML.load_file(Rails.root.join('config/languages.yml'))['languages']
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :birth_date,
      :gender,
      :location,
      :nationality,
      :description,
      :photo,
      :number_of_children,
      availabilities_attributes: [:id, :start, :end, :_destroy]
    )
  end
end
