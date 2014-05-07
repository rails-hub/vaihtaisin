set :environment, :development
set :output, 'tmp/whenever.log'

every 1.day, :at => '12:30 am' do
  runner "Wish.wish_expire_query"
end

every :monday, :at => '1:30 am' do
  runner "Wish.wish_weekly_update"
end

every 1.month, :at => '2:30 am' do
  runner "Wish.wish_monthly_update"
end
