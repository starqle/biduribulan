class Admin::EntriesController < Admin::BaseController
  load_and_authorize_resource

  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry
                  .paginate(:page => params[:page], :per_page => 10)
                  .find_all_by_entry_type(params[:entry_type].presence || 'post', :include => :user)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entries }
    end
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = Entry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entry }
    end
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    @entry = Entry.new(:entry_type => params[:entry_type].presence || 'post', :comment_status => 'open', :user_id => current_user.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entry }
    end
  end

  # GET /entries/1/edit
  def edit
    @entry = Entry.find(params[:id])
  end

  # POST /entries
  # POST /entries.json
  def create
    if params[:entry][:entry_metas_attributes].present?
      params[:entry][:entry_metas_attributes].replace(convert_entry_metas_attributes(params[:entry][:entry_metas_attributes]))
    end
    @entry = Entry.new(params[:entry])
    

    respond_to do |format|
      if @entry.save
        format.html { redirect_to edit_admin_entry_path(@entry), notice: 'Entry was successfully created' }
        format.json { render json: @entry, status: :created, location: @entry }
      else
        format.html { render action: "new" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.json
  def update
    @entry = Entry.find(params[:id])
    params[:entry][:status] = 'publish' if params[:entry][:status] == 'update'
    
    if params[:entry][:entry_metas_attributes].present?
      params[:entry][:entry_metas_attributes].replace(convert_entry_metas_attributes(params[:entry][:entry_metas_attributes]))
    end
    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        format.html { redirect_to edit_admin_entry_path(@entry), notice: 'Entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry = Entry.find(params[:id])
    entry_type = @entry.entry_type
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to admin_entries_url(:entry_type => entry_type)}
      format.json { head :no_content }
    end
  end
  
  
private
  
  # convert or process the entry metas attributes objects
  def convert_entry_metas_attributes(entry_metas_attributes)
    entry_metas_attributes.each do |k, v|
      if(v.count == 4 || v.count == 5)
        entry_metas_attributes[k]['value'] = Time.parse("#{v['date_value(1i)']}-#{v['date_value(2i)']}-#{v['date_value(3i)']}")
      elsif(v.count == 6 || v.count == 7)
        entry_metas_attributes[k]['value'] = Time.parse("#{v['date_value(1i)']}-#{v['date_value(2i)']}-#{v['date_value(3i)']} #{v['date_value(4i)']}:#{v['date_value(5i)']} -0800")
      elsif(v.key('value').blank? && entry_metas_attributes[k]['id'].to_i > 0)
        EntryMeta.find(entry_metas_attributes[k]['id'].to_i).update_attributes(:value => nil)
      end
      entry_metas_attributes[k].keep_if{|k, v| k == 'key' || k == 'value' || k == 'id'}
    end
  end
  

end
