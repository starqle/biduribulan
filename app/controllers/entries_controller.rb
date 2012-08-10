class EntriesController < ApplicationController
  # GET /entries
  # GET /entries.json
  def index
  
    if params[:_entry_type_].present? && params[:_taxonomies_].present?
      @entries = Entry.includes(:taxonomies).where( 'taxonomies.taxonomy_type' => params[:_taxonomies_], 
                                                    'taxonomies.slug' => params[:_slug_], 
                                                    'status' => 'publish', 
                                                    'entry_type' => params[:_entry_type_])

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @entries }
      end
    else
      flash[:notice] = "Access by id is denied"
      redirect_to home_url
    end
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    if params[:_entry_type_].present?
      @entry = Entry.find_by_entry_type_and_name(params[:_entry_type_], params[:_name_])
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @entry }
      end
    else
      flash[:notice] = "Access by id is denied"
      redirect_to home_url
    end
  end

end
