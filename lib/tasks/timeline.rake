namespace :timeline do
  desc "A background process that advances any games in progress"
  task advance_worker: :environment do
    trap('TERM') do
      puts 'BENS SLIGHTLY LESS GRACEFUL SHUTDOWN'
      exit
    end

    trap('SIGINT') do
      puts 'BENS SLIGHTLY LESS GRACEFUL SHUTDOWN #2'
      exit
    end

    loop do
      if Game.in_progress.empty?
        sleep 10
      else
        Game.in_progress.each do |game|
          puts "Advancing game #{game.id}"

          game.advance_game_version if game.require_advance_game_version?
          game.advance_frame

          if game.win_condition?
            game.game_status = GameStatus.find_by_name('finished')
            game.save
          end
        end

        break unless ENV['ADVANCE_CONTINUOUSLY'] == 'true'

        sleep 0.5
      end
    end
  end
end
