class Admin::TaxonomiesController < Admin::BaseController
  load_and_authorize_resource

  # GET /taxonomies
  # GET /taxonomies.json
  def index
    @taxonomies = Taxonomy.find_all_by_taxonomy_type(params[:taxonomy_type].presence || 'category')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taxonomies }
    end
  end

  # GET /taxonomies/1
  # GET /taxonomies/1.json
  def show
    @taxonomy = Taxonomy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @taxonomy }
    end
  end

  # GET /taxonomies/new
  # GET /taxonomies/new.json
  def new
    @taxonomy = Taxonomy.new(:taxonomy_type => params[:taxonomy_type].presence || 'category')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @taxonomy }
    end
  end

  # GET /taxonomies/1/edit
  def edit
    @taxonomy = Taxonomy.find(params[:id])
  end

  # POST /taxonomies
  # POST /taxonomies.json
  def create
    @taxonomy = Taxonomy.new(params[:taxonomy])

    respond_to do |format|
      if @taxonomy.save
        format.html { redirect_to edit_admin_taxonomy_path(@taxonomy), notice: 'Taxonomy was successfully updated.' }
        format.json { render json: @taxonomy, status: :created, location: @taxonomy }
      else
        format.html { render action: "new" }
        format.json { render json: @taxonomy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /taxonomies/1
  # PUT /taxonomies/1.json
  def update
    @taxonomy = Taxonomy.find(params[:id])

    respond_to do |format|
      if @taxonomy.update_attributes(params[:taxonomy])
        format.html { redirect_to edit_admin_taxonomy_path(@taxonomy), notice: 'Taxonomy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :action => 'edit', alert: 'Updating taxonomy was failed.' }
        format.json { render json: @taxonomy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taxonomies/1
  # DELETE /taxonomies/1.json
  def destroy
    @taxonomy = Taxonomy.find(params[:id])
    taxonomy_type = @taxonomy.taxonomy_type 
    @taxonomy.delete_node_keep_sub_nodes
    @taxonomy.reload
    @taxonomy.destroy

    respond_to do |format|
      format.html { redirect_to admin_taxonomies_url(:taxonomy_type => taxonomy_type) }
      format.json { head :no_content }
    end
  end
end
