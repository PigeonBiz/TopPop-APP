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

            routing.redirect 'game'
          end
        end
      end

      routing.on 'game' do
        routing.is do
          # GET /game
          routing.get do
            get_all_videos = Service::AllVideos.new.call

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

      routing.on 'result' do
        routing.is do
          # POST /result
          routing.post do
            player_name = session[:player_name]

            # Calculate score
            player_answer = routing.params
            session[:player_answer] = player_answer

            sort_answer = Service::Sort.new.call
            sort_answer = sort_answer.value!
            session[:sort_answer] = sort_answer

            get_player_score = Service::CountScore.new.call(player_answer)
            if get_player_score.failure?
              flash[:error] = get_player_score.failure
              routing.redirect '/'
            end
            player_score = get_player_score.value!
            session[:player_score] = player_score

            # Save game record to cookie
            session[:records] ||= []
            game_record = {}
            game_record[:player_name] = player_name
            game_record[:time] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
            game_record[:player_score] = player_score
            session[:records].insert(0, game_record).uniq!
            session[:records] = session[:records].slice(0, 15) if session[:records].length > 15

            view 'result', locals: {
              player_name:,
              player_score:
            }
          end
        end
      end

      routing.on 'answer' do
        routing.is do
          routing.get do
            # GET /answer
            view 'answer', locals: {
              videos: session[:videos],
              player_name: session[:player_name],
              player_answer: session[:player_answer],
              sort_answer: session[:sort_answer],
              player_score: session[:player_score]
            }
          end
        end
      end

      routing.on 'records' do
        routing.is do
          # GET /records
          routing.get do
            # Only use browser caching in production
            App.configure :production do
              response.expires 60, public: true
            end

            view 'records', locals: { records: session[:records] }
          end
        end
      end
    end
  end
end
