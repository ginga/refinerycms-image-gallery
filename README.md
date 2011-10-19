# Dynamic Image gallery for Refinery CMS

 This gem is based on refinerycms-page-images gem, with this gem is simple to create a more then one gallery tab in your engines with dynamic columns.

## Requirements

 * refinerycms >= 1.0.8
 
## Features 

 * Select multiple images from the image picker and insert on your engine.
 * Include dynamic fields in gallery for each engine, this is editable in each image.
 * Reordering images with a simple drag into order.

## Install

  Add this line to your applications `Gemfile`
	
	gem 'refinerycms-image-gallery', '~> 0.1.2'
	
  Run:
	
	bundle install
	
## Usage
 
 Creating new gallery for your engine:
	
	rails g refinerycms_image_gallery singular_engine_name:gallery_name attribute:type
	
  For example, if you wanna create new gallery called Top for Post engine:
	
	rails g refinerycms_image_gallery post:top caption:string photographer:string
	
  This generate a new tab Top Gallery in Posts engine.


  But if you wanna generate a new gallery for a engine that already have a gallery, only do this:

	rails g refinerycms_image_gallery post:bottom
	
  This generate a new tab Bottom gallery in Posts engine with the same attributes.

  Note: When you run this line, automaticly generate models, views and run a migrate with relationship between engine and images.

## TODO
 
  * Implement refinery Modules in generator