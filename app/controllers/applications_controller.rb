class ApplicationsController < ApplicationController
  def show
    @application = Application.find_by(name: params[:id])
  end

  def update
    @application = Application.find_by(name: params[:id])
    respond_to do |format|
      if @application.update(application_params)
        format.js { redirect_to application_path(id: @application.name) }
        format.html { redirect_to application_path(id: @application.name) }
      else
        format.js { render 'show' }
        format.html { render 'show' }
      end
    end
  end

  def application_params
    params.require(:application).permit(
      :auto_repo, :data_module, :debug_dir, :debug_enable, :ensure, :options_hash,
      :puppi_enable, :settings_hash, :test_enable, :test_template,
      options_hash_attributes: [:id, :key, :value, :_destroy],
      settings_hash_attributes: [:id, :key, :value, :_destroy],
      confs_attributes: [
        :id, :name, :base_dir, :config_file_notify, :config_file_require, :content, :data_module,
        :debug, :debug_dir, :ensure, :epp, :group, :mode, :owner, :path, :source, :template,
        :template_content,
        :_destroy,
        options_hash_attributes: [:id, :key, :value, :_destroy],
        settings_hash_attributes: [:id, :key, :value, :_destroy]
      ],
      dirs_attributes: [
        :id, :name, :base_dir, :config_dir_notify, :config_dir_require, :data_module, :debug,
        :debug_dir, :ensure, :force, :group, :mode, :owner, :path, :purge, :recurse,
        :source, :vcsrepo,
        :_destroy,
        settings_hash_attributes: [:id, :key, :value, :_destroy]
      ]
    )
  end
end
