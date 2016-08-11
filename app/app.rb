module RubyNew
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers
    enable :sessions
    layout :menu

    ##
    # Caching support.
    #
    # register Padrino::Cache
    # enable :caching
    #
    # You can customize caching store engines:
    #
    # set :cache, Padrino::Cache.new(:LRUHash) # Keeps cached values in memory
    # set :cache, Padrino::Cache.new(:Memcached) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Memcached, :server => '127.0.0.1:11211', :exception_retry_limit => 1)
    # set :cache, Padrino::Cache.new(:Memcached, :backend => memcached_or_dalli_instance)
    # set :cache, Padrino::Cache.new(:Redis) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Redis, :host => '127.0.0.1', :port => 6379, :db => 0)
    # set :cache, Padrino::Cache.new(:Redis, :backend => redis_instance)
    # set :cache, Padrino::Cache.new(:Mongo) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Mongo, :backend => mongo_client_instance)
    # set :cache, Padrino::Cache.new(:File, :dir => Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
    #

    ##
    # Application configuration options.
    #
    # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
    # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, 'foo/bar' # Location for static assets (default root/public)
    # set :reload, false            # Reload application files (default in development)
    # set :default_builder, 'foo'   # Set a custom form builder (default 'StandardFormBuilder')
    # set :locale_path, 'bar'       # Set path for I18n translations (default your_apps_root_path/locale)
    # disable :sessions             # Disabled sessions by default (enable if needed)
    # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    ##
    # You can configure for a specified environment like:
    #
    #   configure :development do
    #     set :foo, :bar
    #     disable :asset_stamp # no asset timestamping for dev
    #   end
    #

    ##
    # You can manage errors like:
    #
    #   error 404 do
    #     render 'errors/404'
    #   end
    #
    #   error 500 do
    #     render 'errors/500'
    #   end
    #

    get "/login" do
      render "login"
    end

    post "/login" do
      data = User.where(:username => params[:username]).first
      session[:user_id] = data[:id]
      redirect "/blog"
    end

    get "/logout" do
      session.clear
      redirect "/login"
    end


    get "/input" do
      render "data_input"
    end

    post "/data_save" do

      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, hard_wrap: true, fenced_code_blocks: true)
      mdr_answer = markdown.render(params[:answer])
      mdr_context = markdown.render(params[:context])
      mdr_example = markdown.render(params[:example])


      @documents = Docu_text.new(:title => params[:title], :language => params[:language], :tags => params[:tags], :answer => mdr_answer, :context => mdr_context, :example => mdr_example)
      @documents.save
      flash.now[:success] = "Documentation Saved"
      render "data_output"
    end

    post "/data_delete" do
      ids = params
      abort
      ids.each do |id|
        @document = Docu_text.where(:id => id).delete
        @document.save
        @documents = Docu_text.all
        redirect "/data_save"
      end

      #render "data_output"


    end

    get "/user_input" do
      @user = User.all
      render "user_input"
    end

    post "/user_save" do
      data = User.new(params)
      data.save
      redirect "/user_input"
    end


    get "/data_output" do
      @documents = Docu_text.all
      render "data_output"
    end

    get "/blog" do
      @bbb = Blog.all
      render "blog"
    end

    post "/blog_save" do
      bbb = Blog.new(params)
      bbb.save
      redirect "/blog"
    end

    post "/blog_delete" do
      id = params[:id]

      bbb = Blog.where(:id => id).delete
      redirect "/blog"
    end




    get "/blog_input" do
      render "blog_input"
    end

    get "/comment" do
      @spec_data = Comment.where(:child_of => nil).all
      @data = Comment.all
      @user = User.all
      render "comment"
    end

    post "/comment_save" do
      data = Comment.new(params)
      data.save
      redirect "/comment"
    end

    post "/comment_reply" do
      newDat = Comment.new
      newDat[:user_id] = session[:user_id]
      newDat[:content] = params[:content]
      newDat[:child_of] = params[:id]
      newDat[:date] = params[:date]
      newDat.save

      redirect "/comment"
    end

    post "/comment_vote" do
      comm = Comment.where(:id => params[:id]).first

      if params[:vote] == "upvote"

        comm[:vote_count] = comm[:vote_count] + 1
        comm.save

      end

      comm.values.to_json

    end

    get "/about" do
      render "about"
    end

  end
end
