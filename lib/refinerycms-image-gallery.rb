######### Require necessary generators for create a new migration #########
require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

class RefinerycmsImageGalleryGenerator < Rails::Generators::NamedBase
  attr_accessor :attributes, :plural_class_name
  
  include Rails::Generators::Migration
  
  ######### Initialize generator with params #########
  def initialize(*args)
    super
    @args = @_initializer.first
    
    @title = @args.first.split(":")
    @name = @title[0]
    @chunk = @title[1]
    @attributes = []
    @column_name = []
    
    # For each param include in migration a new column
    @args.each do |arg|
      unless @args.first == arg
        name = arg.split(":")[0]
        type = arg.split(":")[1]
        @column_name << name
        @attributes << Rails::Generators::GeneratedAttribute.new(name, type)
      end
    end
        
    # Pluralize and camelize the class name
    @plural_name = @name.pluralize
    @plural_class_name = @name.pluralize.camelize
    
    # Check if migration already exists
    @check_migration = ActiveRecord::Base.connection.table_exists?("#{@plural_name}_images")  
    
    # Define view class path
    @file_path = "app/views/admin/#{@plural_name}/"
  end
  
  ######### Define the path for templates #########
  def self.source_root
    @source_root ||= File.dirname(__FILE__) + '/templates'
  end

  ##############################################################################
  ############################# GENERATE MIGRATION #############################
  ##############################################################################
  
  ######### Create a migration relationsheep beetween model and images #########
  def self.next_migration_number(path)
    ActiveRecord::Generators::Base.next_migration_number(path)
  end

  def generate_migration
    unless @check_migration
      migration_template 'migration.rb', "db/migrate/create_#{plural_name}_images"
      run "rake db:migrate"
    end
  end 
  
  ##############################################################################
  ######################## OVERRIDE FILES IF NECESSARY #########################
  ##############################################################################
  
  ######### Override the image model if not exists ######### 
  def override_image_model
    run "rake refinery:override model=image"
  end unless File.exists?("app/models/image.rb")
  
  ######### Override the class model if not exists ######### 
  def override_class_model
    unless File.exists?("app/models/#{@name}.rb")
      run "rake refinery:override model=#{@name}"
    end
  end 
  
  ######### Override your class admin/_form item if not exists #########
  def override_class_form
    unless File.exists?("app/views/admin/#{@plural_name}/_form.html.erb")
      run "rake refinery:override view=admin/#{plural_name}/_form"
    end
  end 
  
  ######### Override inset image view if not exists ######### 
    def override_insert_image
      run "rake refinery:override view=admin/images/insert"
    end unless File.exists?("app/views/admin/images/insert.html.erb")
    
  ######### Override refinery admin javascript ######### 
  def override_javascripts
    run "rake refinery:override javascript=refinery/admin"
  end unless File.exists?("public/javascripts/refinery/admin.js")
  
  ##############################################################################
  ############################## GENERATE MODELS ###############################
  ##############################################################################
  
  ######### Create relationsheep model #########
  def create_model
    unless @check_migration
      template 'models/model.rb', File.join('app/models', class_path, "#{plural_name}_image.rb")
    end
  end
    
  ######### Insert into models new relations #########
  def insert_into_model
    unless @check_migration
      @columns = []
      @column_name.each do |column|
        @columns << ":" + column.to_s + " => image_data['#{column}']"
      end
    
      # Insert into image model
      insert_into_file "app/models/image.rb", :after => "image_accessor :image\n" do
        "\thas_many :#{plural_name}_images\n" +
        "\thas_many :#{plural_name}, :through => :#{plural_name}_images\n"
      end   
    
      # Insert into object model
      insert_into_file "app/models/#{@name}.rb", :after => "ActiveRecord::Base\n" do
        "\n\thas_many :#{plural_name}_images\n" +
        "\thas_many :images, :through => :#{plural_name}_images\n" +
        "\n\tdef images_attributes=(data)
      #{plural_class_name}Image.delete_all(:#{@name}_id => self.id)
      data.each_with_index do | ( k, image_data ), i |
        if image_data['id'].present?
          image_gallery = self.#{plural_name}_images.new(
                                                          :image_id => image_data['id'].to_i, 
                                                          :position => i, 
                                                          :chunk => image_data['chunk'], 
                                                          #{@columns.join(', ')}
                                                        )
          self.articles_images << image_gallery
        end
        self.touch
      end
    end\n"
      end   
    end
  end
  
  ##############################################################################
  ########################## GENERATE VIEWS TEMPLATES ##########################
  ##############################################################################
  
  ######### Insert into view image gallery tab #########
  def add_tab_to_form
    unless File.exists?("#{file_path}/_images_field_#{@chunk}.html.erb")
      page_parts = open("app/views/admin/#{@plural_name}/_form.html.erb").grep(/page_parts/)
      
      if page_parts.empty?
        insert_into_file "app/views/admin/#{@plural_name}/_form.html.erb",
          :before => '<%= render :partial => "/shared/admin/form_actions",' do
            "\n\t<div class='field'>" +
              "\n\t\t<div id='page-tabs' class='clearfix ui-tabs ui-widget ui-widget-content ui-corner-all'>" +
                "\n\t\t\t<ul id='page_parts'>" +
                  "\n\t\t\t\t<li class='ui-state-default'>" +
                    "\n\t\t\t\t\t<%= link_to '#{@chunk.camelize} Gallery', '##{@chunk}_gallery' %>" +
                  "\n\t\t\t</li>"+
                "\n\t\t\t</ul>" +
                
                "\n\n\t\t\t<div id='page_part_editors'>" +
                  "\n\t\t\t\t<div class='page_part' id='#{@chunk}_gallery'>" +
                    "\n\t\t\t\t\t<%= render :partial => 'images', :locals => { :f => f, :chunk_name => '#{@chunk}' } -%>" +
                  "\n\t\t\t\t</div>" +
                "\n\t\t\t</div>" +
              "\n\t\t</div>" +
            "\n\t</div>\n"
        end 
      else
        insert_into_file "app/views/admin/#{@plural_name}/_form.html.erb",
          :after => "<ul id='page_parts'>" do
            "\n\t\t<li class='ui-state-default'>" +
              "\n\t\t\t<%= link_to '#{@chunk.camelize} Gallery', '##{@chunk}_gallery' %>" +
            "\n\t\t</li>"
        end 
  
        insert_into_file "app/views/admin/#{@plural_name}/_form.html.erb",
          :after => "<div id='page_part_editors'>" do
            "\n\t\t<div class='page_part' id='#{@chunk}_gallery'>" +
              "\n\t\t\t<%= render :partial => 'images', :locals => { :f => f, :chunk_name => '#{@chunk}' } -%>" +
            "\n\t\t</div>"
        end
      end
    end
  end
  
  ######### Insert into form partial the javascripts and css #########
  def add_js_and_css_to_form
    unless @check_migration
      page_options = open("app/views/admin/#{@plural_name}/_form.html.erb").grep(/content_for :javascripts/)
      
      if page_options.empty?
        insert_into_file "app/views/admin/#{@plural_name}/_form.html.erb",
          :before => "<%= form_for" do
            "<% content_for :javascripts do %>" +
              "\n\t<script>" +
                "\n\t\t$(document).ready(function(){" +
                  "\n\t\t\tpage_options.init(false, '', '');" +
                "\n\t\t});" +
              "\n\t</script>"+
              "\n\t<%= javascript_include_tag 'gallery' %>" +
            "\n<% end %>" +
          
            "\n\n<% content_for :stylesheets do %>" +
              "\n\t<%= stylesheet_link_tag 'gallery' %>" +
            "\n<% end %>\n\n"
        end
      else
        insert_into_file "app/views/admin/#{@plural_name}/_form.html.erb",
          :after => "<% content_for :javascripts do %>" do
            "\n\t<%= javascript_include_tag 'gallery' %>"
        end
        
        insert_into_file "app/views/admin/#{@plural_name}/_form.html.erb",
          :before => "<% content_for :javascripts do %>" do
            "\n<% content_for :stylesheets do %>" +
              "\n\t<%= stylesheet_link_tag 'gallery' %>" +
            "\n<% end %>\n"
        end
      end
    end
  end
  
  ######### Insert into insert image template new params #########
  def insert_image_params
    unless @check_migration
      insert_into_file "app/views/admin/images/insert.html.erb",
        :after => 'image_dialog.init(<%= @callback.present? ? "self.parent.#{@callback}" : "null" %>' do
          ", '<%= params[:chunk] %>'"
      end
    end
  end
  
  ######### Create view partial templates for images in gallery #########
  def create_view_templates
    unless @check_migration
      template 'views/images.html.erb', File.join(file_path, class_path, "_images.html.erb")
      template 'views/image.html.erb', File.join(file_path, class_path, "_image.html.erb")
      template 'views/images_field.html.erb', File.join(file_path, class_path, "_images_field_#{@chunk}.html.erb")
    else
      unless File.exists?("#{file_path}/_images_field_#{@chunk}.html.erb")
        template 'views/images_field.html.erb', File.join(file_path, class_path, "_images_field_#{@chunk}.html.erb")
      end
    end
  end
  
  ##############################################################################
  ########################## GENERATE JAVASCRIPTS/CSS ##########################
  ##############################################################################

  ######### Inserto into admin javascript chunk params #########
  def insert_chunk_admin_js
    js_admin_path = "public/javascripts/refinery/admin.js"
    unless @check_migration
      insert_into_file "#{js_admin_path}","\n, chunk: null", :after => ", callback: null"
      insert_into_file "#{js_admin_path}", ",chunk", :after => ", init: function(callback"  
      insert_into_file "#{js_admin_path}","\n\t\tthis.chunk = chunk;", :after => "this.callback = callback;"
      insert_into_file "#{js_admin_path}", ", this.chunk", :after => "this.callback(img_selected"
    end
  end

  def copy_javascript
    template "javascripts/gallery.js", File.join("public/javascripts", class_path, "gallery.js") unless @check_migration
  end
  
  def copy_css
    template "stylesheets/gallery.css", File.join("public/stylesheets", class_path, "gallery.css")  unless @check_migration
  end

end