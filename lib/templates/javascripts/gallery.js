/* DO NOT MODIFY. This file was compiled Thu, 22 Sep 2011 19:50:13 GMT from
 * /Users/vinicius/workspace/gem-gallery-image/app/coffeescripts/gallery.coffee
 */

var image_added, open_edit_image;
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
  return $('li.image_field').live('hover', function() {
    var chunk;
    chunk = $(this).find('input').first().val();
    return $("#page_images_" + chunk).sortable();
  });
});
open_edit_image = function(items, image_id) {
  var fields, input;
  fields = $(items).clone();
  input = fields.find('input');
  input.each(function(i, inp) {
    var title, value;
    title = $(inp).attr('class').replace('edit_items_', '');
    value = $(inp).val();
    return $(inp).after($("<div id='image" + image_id + "_title_" + title + "'><span class= 'image-fields-edit'>" + title.toUpperCase() + "</span><textarea class='image-edit'>" + value + "</textarea></div>"));
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
      var input_val, title;
      title = $(inp).attr('class').replace('edit_items_', '');
      input_val = $(items).find("input.edit_items_" + title);
      input_val.val($("div#image" + image_id + "_title_" + title).find("textarea").val());
      return fields.dialog('close');
    });
    return fields.remove();
  });
};