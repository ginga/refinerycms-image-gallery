var create_date, create_fields, days_in_month, image_added, open_edit_image;
image_added = function(image, chunk) {
  var dynamic_items, id, image_id, img, new_list, target;
  image_id = $(image).attr('id').replace('image_', '');
  new_list = $("li.empty_" + chunk).clone();
  new_list.find('input').next().val(image_id);
  new_list.find('span').html($(image).attr('alt'));
  id = parseInt(image_id + Math.random() * 101);
  $('input', new_list).each(function(i, input) {
    input = $(input);
    input.attr('name', input.attr('name').replace(/images_attributes\]\[[\d]+/, "images_attributes][" + id));
    return input.attr('id', input.attr('id').replace(/images_attributes_[\d]+/, "images_attributes_" + id));
  });
  img = $("<img />").attr({
    title: $(image).attr('title'),
    alt: $(image).attr('alt'),
    src: $(image).attr('data-grid')
  }).appendTo(new_list);
  dynamic_items = new_list.find("#dynamic_items");
  dynamic_items.attr('id', "dynamic_items_" + image_id);
  dynamic_items.find("input").val("");
  new_list.attr('id', "image_" + image_id).removeClass('empty');
  new_list.attr('id', "image_" + image_id).removeClass("empty_" + chunk);
  new_list.show();
  target = "#page_images_" + chunk;
  return new_list.appendTo(target);
};
jQuery(function() {
  $('.edit_image').live('click', function() {
    var image_id, items;
    image_id = $(this).parents().parents().attr('id').replace('image_', '');
    items = $(this).parents().parents().find("#dynamic_items_" + image_id)[0];
    return open_edit_image(items, image_id);
  });
  $('.delete_image').live('click', function() {
    var rm;
    rm = confirm("Are you sure delete this image?");
    if (rm === true) {
      return $(this).parents('li').first().remove();
    } else {
      return false;
    }
  });
  $('li.image_field').live('hover', function() {
    var chunk;
    chunk = $(this).find('input').first().val();
    return $("#page_images_" + chunk).sortable();
  });
  return $("#month, #year").live('change', function() {
    var month, year;
    year = $("#year").find(":selected").val();
    month = $("#month").find(":selected").val();
    return days_in_month(year, month);
  });
});
open_edit_image = function(items, image_id) {
  var fields, input;
  fields = $(items).clone();
  input = fields.find('input');
  input.each(function(i, inp) {
    var field, title, type, value;
    title = $(inp).attr('data-name');
    type = $(inp).attr('data-type');
    value = $(inp).val();
    field = create_fields(type, value);
    return $(inp).after($("<div id='image" + image_id + "_title_" + title + "'><span class= 'image-fields-edit'>" + title + "</span>" + field + "</div>"));
  });
  input.after($("<div class='form-actions'><div class='form-actions-left'><a class='button' id='insert_fields'>Insert<a></div></div>"));
  fields.dialog({
    title: "Edit Image Fields",
    modal: true,
    resizable: false,
    autoOpen: true,
    width: 800,
    height: 500
  });
  return $('a#insert_fields').click(function() {
    input.each(function(i, inp) {
      var date, date_value, field, hour, input_val, minute, title, type;
      title = $(inp).attr('data-name');
      type = $(inp).attr('data-type');
      if (type === "string" || type === "integer" || type === "float" || type === "decimal") {
        field = "input";
      } else if (type === "boolean") {
        field = "input-checkbox";
      } else if (type === "text") {
        field = "textarea";
      } else if (type === "date" || type === "datetime") {
        field = "select";
      }
      input_val = $(items).find("input[data-name='" + title + "']");
      if (field === "select") {
        date_value = [];
        $("div#image" + image_id + "_title_" + title).find("" + field).each(function() {
          return date_value.push($(this).val());
        });
        date = "" + date_value[0] + "-" + date_value[1] + "-" + date_value[2];
        hour = date_value[3];
        minute = date_value[4];
        if (hour) {
          date = "" + date + " " + hour + ":" + minute;
        }
        input_val.val(date);
      } else if (field === "input-checkbox") {
        field = field.split("-");
        if ($("div#image" + image_id + "_title_" + title).find("" + field[0]).is(":checked")) {
          input_val.val("true");
        } else {
          input_val.val("false");
        }
      } else {
        input_val.val($("div#image" + image_id + "_title_" + title).find("" + field).val());
      }
      return fields.dialog('close');
    });
    return fields.remove();
  });
};
create_fields = function(type, value) {
  var checked, field;
  switch (type) {
    case "string":
    case "integer":
    case "float":
    case "decimal":
      return field = "<input class='image-edit' type='text' value='" + value + "' />";
    case "boolean":
      checked = '';
      if (value === "true") {
        checked = "checked";
      }
      return field = "<input class='image-edit-checkbox' type='checkbox' " + checked + " />";
    case "text":
      return field = "<textarea class='image-edit'>" + value + "</textarea>";
    case "date":
      if (value) {
        value = value.split("-");
        return field = "<select id='year'><option></option>" + (create_date(2010, 2030, 'year', value[0])) + "</select>                 <select id='month'><option></option>" + (create_date(1, 12, 'month', value[1])) + "</select>                 <select id='day'><option></option>" + (create_date(1, '', 'day', value)) + "</select>";
      } else {
        return field = "<select id='year'><option></option>" + (create_date(2010, 2030, 'year')) + "</select>                 <select id='month'><option></option>" + (create_date(1, 12, 'month')) + "</select>                 <select id='day'><option></option>" + (create_date(1, '', 'day')) + "</select>";
      }
      break;
    case "datetime":
      if (value) {
        value = value.split("-");
        return field = "<select id='year'><option></option>" + (create_date(2010, 2030, 'year', value[0])) + "</select>                 <select id='month'><option></option>" + (create_date(1, 12, 'month', value[1])) + "</select>                 <select id='day'><option></option>" + (create_date(1, '', 'day', value)) + "</select>                 <select id='hour'><option></option>" + (create_date(00, 23, 'hour', value.join("-"))) + "</select>                 <select id='minute'><option></option>" + (create_date(00, 59, 'minute', value.join("-"))) + "</select>";
      } else {
        return field = "<select name='date[0]' id='year'><option></option>" + (create_date(2010, 2030, 'year')) + "</select>                 <select name='date[1]' id='month'><option></option>" + (create_date(1, 12, 'month')) + "</select>                 <select name='date[2]' id='day'><option></option>" + (create_date(1, '', 'day')) + "</select>                 <select name='date[3]' id='hour'><option></option>" + (create_date(00, 23, 'hour')) + "</select>                 <select name='date[4]' id='minute'><option></option>" + (create_date(00, 59, 'minute')) + "</select>";
      }
  }
};
create_date = function(init, end, obj_id, value) {
  var day, month, selected, year, _ref, _ref2, _results;
  if (obj_id === 'day' && !value) {
    year = new Date().getFullYear();
    month = new Date().getMonth();
    end = new Date(year, month + 1, 0).getDate();
  } else if (obj_id === 'day' && value) {
    year = new Date(value).getFullYear();
    month = new Date(value).getMonth() + 1;
    day = new Date(value).getDate();
    end = new Date(year, month, 0).getDate();
  }
  _results = [];
  for (init = _ref = init, _ref2 = end; _ref <= _ref2 ? init <= _ref2 : init >= _ref2; _ref <= _ref2 ? init++ : init--) {
    selected = '';
    if (value) {
      if (obj_id === 'year' && init === new Date(value, 1).getFullYear()) {
        selected = 'selected';
      }
      if (obj_id === 'month' && init === new Date(0, value).getMonth()) {
        selected = 'selected';
      }
      if (obj_id === 'day' && init === new Date(year, month, day).getDate()) {
        selected = 'selected';
      }
      if (obj_id === 'hour' && init === new Date(value).getUTCHours()) {
        selected = 'selected';
      }
      if (obj_id === 'minute' && init === new Date(value).getUTCMinutes()) {
        selected = 'selected';
      }
    }
    _results.push("<option value='" + init + "' " + selected + " >" + init + "</option>");
  }
  return _results;
};
days_in_month = function(year, month) {
  var end, init, _ref, _ref2, _results;
  $("#day").empty();
  init = 1;
  end = new Date(year, month, 0).getDate();
  _results = [];
  for (init = _ref = init, _ref2 = end; _ref <= _ref2 ? init <= _ref2 : init >= _ref2; _ref <= _ref2 ? init++ : init--) {
    _results.push($("#day").append("<option value='" + init + "'>" + init + "</option>"));
  }
  return _results;
};