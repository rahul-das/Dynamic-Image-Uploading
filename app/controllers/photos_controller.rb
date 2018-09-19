class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @photo = Photo.find(params[:id])
  end

  # GET /photos/new
  def new
    # @photo = Photo.new
    # @photo1 = Photo.new
    # @photo2 = Photo.new
    # @photo3 = Photo.new
    # @photo4 = Photo.new
    @photos = Photo.all

    @empty_photos = []

    5.times do
        @empty_photos << Photo.new
    end
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos
  # POST /photos.json
  def create

    # build a photo and pass it into a block to set other attributes
    @photo = Photo.new(photo_params) do |t|
      if params[:photo][:data]
        t.data      = params[:photo][:data].read
        t.filename  = params[:photo][:data].original_filename
        t.mime_type = params[:photo][:data].content_type
      end
    end

    # normal save
    if @photo.save
      redirect_to new_photo_url
    else
      render :action => "new"
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to(photos_url)
  end

  def serve
    @photo = Photo.find(params[:id])
    send_data(@photo.data, :type => @photo.mime_type, :filename => "#{@photo.name}.jpg", :disposition => "inline")
  end

  def upload_multiple
    params[:photos].each do |photo|
      if photo[:data]
        data      = photo[:data].read
        filename  = photo[:data].original_filename
        mime_type = photo[:data].content_type
        Photo.create( name: photo[:name], data: data, filename: filename, mime_type: mime_type )
      end
    end

    # @photos = params[:photos].map do |photo_params|
    #   @photo = Photo.new(photo_params) do |t|
    #     if
    #       t.data      = params[:photo][:data].read
    #       t.filename  = params[:photo][:data].original_filename
    #       t.mime_type = params[:photo][:data].content_type
    #     end
    #   end
    #   @photo.save
    # end

    redirect_to new_photo_url
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:name, :data, :filename, :mime_type)
    end
end
