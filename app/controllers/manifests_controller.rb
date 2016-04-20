class ManifestsController < ApplicationController
  def show
    @manifest = Manifest.first_or_create
  end

  def add
    @manifest = Manifest.first_or_create
    @application = @manifest.applications.find_or_create_by(name: params[:application])
    redirect_to :manifest
  end
end