# Dynamic Image gallery for Refinery CMS

 This gem is based on refinerycms-page-images gem, but with this gem is simple to create a new gallery tab in your engines with dynamic columns. It's possible to create more than one galleries in the same engine.

## Requirements

 * refinerycms >= 1.0.8
 
## Features 

 * Select multiple images from the image picker and insert on your engine.
 * Include dynamic fields in gallery for each engine, this editable in each image.
 * Reordering images with a simple drag into order.

## Install

  Add this line to your applications `Gemfile`
	
	gem 'refinerycms-image-gallery'
	
  Next run
	
	bundle install
	
## Usage
 
 Creating new gallery for your engine:
	
	rails g refinerycms_image_gallery *singular_engine_name:gallery_name* *attribute:type*
	
  For example, if you wanna create new gallery called Top for Post engine:
	
	rails g refinerycms_image_gallery post:top caption:string photographer:string
	
  This generate a new tab Top Gallery in Posts engine.


  But if you wanna generate a new gallery for a engine already have a gallery, only do this:

	rails g refinerycms_image_gallery post:bottom
	
  This generate a new tab Bottom gallery in Posts engine with the same attributes.

  Note: When you run this line, automaticly generate models views and run a migrate with relationship between engine and images.


# Copyright

Copyright (c) 2011 Vinicius Zago. See LICENSE for
further details.

