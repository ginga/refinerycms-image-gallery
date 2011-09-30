class <%= plural_class_name %>Image < ActiveRecord::Base
  belongs_to :image
  belongs_to :<%= name %>
end