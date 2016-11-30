# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
  process :tags => ['posted_picture_' + ENV['CLOUDINARY_USER'] ]
end
