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

  # Call function to change days of month
  $("#month, #year").live 'change', ->
    year = $("#year").find(":selected").val()
    month = $("#month").find(":selected").val()
    days_in_month year, month

# Dialog dynamic items
open_edit_image = (items, image_id) ->
  # Clone dynamic fields for modal
  fields = $(items).clone()
  input = fields.find('input')

  # For each input create a textarea for edit
  input.each (i, inp) ->
    title = $(inp).attr('data-name')
    type = $(inp).attr('data-type')
    value = $(inp).val()

    # Call function to create dynamic fields type
    field = create_fields(type, value)

    $(inp).after $("<div id='image#{image_id}_title_#{title}'><span class= 'image-fields-edit'>#{title}</span>#{field}</div>")

  # Input a submit button
  input.after($("<div class='form-actions'><div class='form-actions-left'><a class='button' id='insert_fields'>Insert<a></div></div>"))

  # Open the dialog modal
  fields.dialog({
               title: "Edit Image Fields",
               modal: true,
               resizable: false,
               autoOpen: true,
               width: 800,
               height: 500
  })

  # Insert click function
  $('a#insert_fields').click ->
    # For each input get the textarea value and change input value
    input.each (i, inp) ->
      title = $(inp).attr('data-name')
      type = $(inp).attr('data-type')
      if type == "string" || type == "integer" || type == "float" || type == "decimal"
        field = "input"
      else if type == "boolean"
        field = "input-checkbox"
      else if type == "text"
        field = "textarea"
      else if type == "date" || type == "datetime"
        field = "select"

      input_val = $(items).find("input[data-name='#{title}']")

      # Make data for select
      if field == "select"
        date_value = []
        
        $("div#image#{image_id}_title_#{title}").find("#{field}").each ->
          date_value.push $(this).val()

        date = "#{date_value[0]}-#{date_value[1]}-#{date_value[2]}"
        hour = date_value[3]
        minute = date_value[4]
        if hour
          date = "#{date} #{hour}:#{minute}"

        input_val.val(date) 
      # Check if checkbox is selected 
      else if field == "input-checkbox"
        field = field.split("-")
        if $("div#image#{image_id}_title_#{title}").find("#{field[0]}").is(":checked")
          input_val.val("true")
        else
          input_val.val("false")
      # Input value for input text fields
      else
        input_val.val $("div#image#{image_id}_title_#{title}").find("#{field}").val()

      fields.dialog('close')

    # Remove cloned div after close
    fields.remove()

# Create Fields for each type of element
create_fields = (type, value) ->
  switch type
    when "string", "integer", "float", "decimal"
      field = "<input class='image-edit' type='text' value='#{value}' />"
    when "boolean"
      checked = ''
      if value == "true"
        checked = "checked"
      field = "<input class='image-edit-checkbox' type='checkbox' #{checked} />"
    when "text"
      field = "<textarea class='image-edit'>#{value}</textarea>"
    when "date"
      if value 
        value = value.split("-")
        field = "<select id='year'><option></option>#{create_date(2010, 2030, 'year', value[0])}</select>
                 <select id='month'><option></option>#{create_date(1, 12, 'month', value[1])}</select>
                 <select id='day'><option></option>#{create_date(1,'', 'day', value)}</select>"
      else
        field = "<select id='year'><option></option>#{create_date(2010, 2030,'year')}</select>
                 <select id='month'><option></option>#{create_date(1, 12,'month')}</select>
                 <select id='day'><option></option>#{create_date(1,'','day')}</select>"
     when "datetime"
      if value 
        value = value.split("-")
        field = "<select id='year'><option></option>#{create_date(2010, 2030, 'year', value[0])}</select>
                 <select id='month'><option></option>#{create_date(1, 12, 'month', value[1])}</select>
                 <select id='day'><option></option>#{create_date(1,'', 'day', value)}</select>
                 <select id='hour'><option></option>#{create_date(00, 23, 'hour', value.join("-"))}</select>
                 <select id='minute'><option></option>#{create_date(00,59, 'minute', value.join("-"))}</select>"
      else
        field = "<select name='date[0]' id='year'><option></option>#{create_date(2010, 2030,'year')}</select>
                 <select name='date[1]' id='month'><option></option>#{create_date(1, 12,'month')}</select>
                 <select name='date[2]' id='day'><option></option>#{create_date(1,'','day')}</select>
                 <select name='date[3]' id='hour'><option></option>#{create_date(00, 23, 'hour')}</select>
                 <select name='date[4]' id='minute'><option></option>#{create_date(00, 59, 'minute')}</select>"
        
# Create options for date select
create_date = (init, end, obj_id, value) ->
  # Set days in month
  if obj_id == 'day' && !value
    year = new Date().getFullYear()
    month = new Date().getMonth()
    end = new Date( year, month + 1, 0 ).getDate()
  else if obj_id == 'day' && value
    year = new Date(value).getFullYear()
    month = (new Date(value).getMonth() + 1) 
    day = new Date(value).getDate()
    end = new Date( year, month, 0 ).getDate();
  

  for init in [(init)..(end)]
    selected = ''
    
    if value 
      # Selected Year
      if obj_id == 'year' && init == new Date(value,1).getFullYear()
        selected = 'selected'
      # Selected Month
      if obj_id == 'month' && init == new Date(0,value).getMonth()
        selected = 'selected'
      # Selected Day
      if obj_id == 'day' && init == new Date(year, month, day).getDate()
        selected = 'selected'
      # Selected Hour
      if obj_id == 'hour' && init == new Date(value).getUTCHours()
        selected = 'selected'
      # Selected Minute
      if obj_id == 'minute' && init == new Date(value).getUTCMinutes()
        selected = 'selected'
      
    "<option value='#{init}' #{selected} >#{init}</option>"

# Get max days in month  
days_in_month = (year, month) ->
  $("#day").empty()
  init = 1
  end = new Date(year,month,0).getDate()
  for init in [(init)..(end)]
    $("#day").append "<option value='#{init}'>#{init}</option>"