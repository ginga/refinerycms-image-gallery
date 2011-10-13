# Function to Add New Image
image_added = (image, chunk) ->
  image_id = $(image).attr('id').replace 'image_', '' # Get image id for new list item id
  new_list = $("li.empty_#{chunk}").clone() # Clone empty li to new list
  new_list.find('input').next().val image_id # Set input image_id value = image_id
  new_list.find('span').html($(image).attr('alt'))

  # Set random values items id/name
  id = parseInt(image_id + Math.random() * 101)
  $('input', new_list).each (i,input) ->
    input = $(input)
    input.attr('name', input.attr('name').replace(/images_attributes\]\[[\d]+/, "images_attributes][" + id))
    input.attr('id', input.attr('id').replace(/images_attributes_[\d]+/, "images_attributes_" + id))

  # Append thumb to new list
  img = $("<img />").attr({
    title: $(image).attr('title')
    , alt: $(image).attr('alt')
    , src: $(image).attr('data-grid')
  }).appendTo(new_list)

  # Get dynamic items and set id/val
  dynamic_items = new_list.find "#dynamic_items"
  dynamic_items.attr 'id', "dynamic_items_#{image_id}"
  dynamic_items.find("input").val ""

  # Remove class and show new list
  new_list.attr('id', "image_#{image_id}").removeClass 'empty'
  new_list.attr('id', "image_#{image_id}").removeClass "empty_#{chunk}"
  new_list.show()

  # Append new list to correct gallery
  target = "#page_images_#{chunk}"
  new_list.appendTo target

# Function to edit image fields
jQuery ->
  # Edit image fields
  $('.edit_image').live 'click', ->
    image_id = $(this).parents().parents().attr('id').replace 'image_', '' # Get image id
    items = $(this).parents().parents().find("#dynamic_items_#{image_id}")[0] # Get dynamic items of this list
    open_edit_image items, image_id # Call function open modal

  # Delete image from gallery
  $('.delete_image').live 'click', ->
    rm = confirm "Are you sure delete this image?"
    if(rm == true)
      $(this).parents('li').first().remove()
    else
      return false

  # Reoder images
  $('li.image_field').live 'hover', ->
    chunk = $(this).find('input').first().val()
    $("#page_images_#{chunk}").sortable()

# Dialog dynamic items
open_edit_image = (items, image_id) ->
  # Clone dynamic fields for modal
  fields = $(items).clone()
  input = fields.find('input')

  # For each input create a textarea for edit
  input.each (i, inp) ->
    title = $(inp).attr('class').replace 'edit_items_', ''
    value = $(inp).val()
    $(inp).after $("<div id='image#{image_id}_title_#{title}'><span class='ui-dialog-title' id='ui-dialog-title-1' style='width: 300px; background: #22A7F2;float:left;'>#{title}</span><textarea style='width: 290px; height: 30px;'>#{value}</textarea></div>")

  # Input a submit button
  input.after($("<div class='form-actions'><div class='form-actions-left'><a class='button' id='insert_fields'>Insert<a></div></div>"))

  # Open the dialog modal
  fields.dialog({
               title: "Edit Image Fields",
               modal: true,
               resizable: false,
               autoOpen: true,
               height:300
  })

  # Insert click function
  $('a#insert_fields').click ->
    # For each input get the textarea value and change input value
    input.each (i, inp) ->
      title = $(inp).attr('class').replace 'edit_items_', ''
      input_val = $(items).find("input.edit_items_#{title}")
      input_val.val $("div#image#{image_id}_title_#{title}").find("textarea").val()
      fields.dialog('close')

    # Remove cloned div after close
    fields.remove()
