class Create<%= plural_class_name %>Images < ActiveRecord::Migration
  def self.up
    create_table :<%= plural_name %>_images do |t|
      t.integer :<%= @name %>_id
      t.integer :image_id
      t.integer :position
      t.string :chunk
    <%- for attribute in attributes -%>
      t.<%= attribute.type %> :<%= attribute.name %>
    <%- end -%>

      t.timestamps
    end
  end

  def self.down
    drop_table :<%= plural_name %>_images
  end
end