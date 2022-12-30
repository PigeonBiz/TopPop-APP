# frozen_string_literal: true

require 'roda'
require 'rack'

module TopPop
  # Web App
  class App < Roda
    plugin :render, views: 'app/presentation/views_html'
    plugin :assets, path: 'app/presentation/assets', css: 'style.css'
    plugin :common_logger, $stderr
    plugin :halt
    plugin :flash
    plugin :all_verbs # allows HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :common_logger, $stderr
    plugin :caching

    use Rack::MethodOverride 

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      routing.root do
        # GET /
        view 'home'
      end

      # Virtual route to verify and save player's input 
      routing.on 'player' do
        routing.is do
          # POST /player
          routing.post do
            # Get player name
            player_name_monad = Forms::PlayerName.new.call(routing.params)
            input_verified = Service::VerifyInput.new.call(player_name_monad)

            if input_verified.failure?
              flash[:error] = input_verified.failure
              routing.redirect '/'
            end

            # Save player name into cookie
            player_name = player_name_monad.to_h[:player_name]
            session[:player_name] = player_name

            flash[:notice] = "Hi #{player_name}! Welcome to TopPop!"

            routing.redirect "game"
          end
        end      
      end

      routing.on 'game' do
        routing.is do
          # GET /game
          routing.get do
            get_all_videos = Service::AllVideos.new.call()

            if get_all_videos.failure?
              flash[:error] = get_all_videos.failure
              routing.redirect '/'
            end

            all_videos = get_all_videos.value!.videos
            viewable_videos = Views::VideoList.new(all_videos)

            session[:videos] = viewable_videos  

            # Only use browser caching in production
            App.configure :production do
              response.expires 60, public: true
            end

            view 'game', locals: { videos: viewable_videos }
          end
        end     
      end
              
      routing.on 'results' do
        routing.is do 
          # POST /test
          routing.post do
            user_rankings = routing.params
            player_name = session[:player_name] 
            viewable_videos = session[:videos]
            
            view 'results', locals: { 
              videos: viewable_videos,  
              user_rankings: user_rankings, 
              player_name: player_name
            }
          end
        end      
      end
    end
  end
end
