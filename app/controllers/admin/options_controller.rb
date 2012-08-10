class Admin::OptionsController < Admin::BaseController
  load_and_authorize_resource

  # GET /options
  # GET /options.json
  def index
    #if params[:option_type].present?
      @options = Option.find_all_by_option_type('custom_field')
      @options.each{|opt| opt.value = YAML.load(opt.value)}
    #else
    #  @options = Option.all
    #end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @options }
    end
  end

  # GET /options/1
  # GET /options/1.json
  def show
    @option = Option.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @option }
    end
  end

  # GET /options/new
  # GET /options/new.json
  def new
    @option = Option.new(:option_type => 'custom_field')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @option }
    end
  end

  # GET /options/1/edit
  def edit
    @option = Option.find(params[:id])
    @option.value = YAML.load(@option.value)
  end

  # POST /options
  # POST /options.json
  def create
    @option = Option.new(params[:option])

    value = {'entry_types' => params[:entry_types], 'fields' => []}
    if params[:field].present?
      params[:field].each do |k, v|
        value['fields'] << v if v['name'].present?
      end
    end               
    @option.value = YAML.dump(value)

    respond_to do |format|
      if @option.save
        format.html { redirect_to edit_admin_option_path(@option), notice: 'Option was successfully updated.' }
        format.json { render json: @option, status: :created, location: @option }
      else
        format.html { render action: "new" }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /options/1
  # PUT /options/1.json
  def update
    @option = Option.find(params[:id])
    
    value = {'entry_types' => params[:entry_types], 'fields' => []}
    if params[:field].present?
      params[:field].each do |k, v|
        value['fields'] << v if v['name'].present?
      end
    end               
    @option.value = YAML.dump(value)

    respond_to do |format|
      if @option.update_attributes(params[:option])
        format.html { redirect_to edit_admin_option_path(@option), notice: 'Option was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :action => 'edit', alert: 'Updating option was failed.' }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /options/1
  # DELETE /options/1.json
  def destroy
    @option = Option.find(params[:id])
    option_type = @option.option_type
    @option.destroy

    respond_to do |format|
      format.html { redirect_to admin_options_url(:option_type => option_type) }
      format.json { head :no_content }
    end
  end
end
