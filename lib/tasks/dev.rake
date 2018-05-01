namespace :dev do
  task fake_user: :environment do
    20.times do |i|
      name = FFaker::Name::first_name

      file = File.open("#{Rails.root}/public/avatar/user#{i+1}.jpg")

      # 這組路徑在 Heroku 上無法使用，同學可跳過 Heroku 上圖片顯示的問題
      # 若特別想攻克的同學可參考 Filestack 說明 => https://lighthouse.alphacamp.co/units/1110      

      user = User.new(
        name: name,
        email: "#{name}@example.com",
        password: "12345678",
        description: FFaker::Lorem::sentence(30),
        avatar: file
      )

      user.save!
      puts user.name
    end
  end
  task fake_post: :environment do 
    Post.destroy_all
    User.all.each do |user|
      3.times do |i|
        Post.create!(
          title:FFaker::Lorem::sentence(4),
          author_id: user.id,
          content: FFaker::Lorem::sentence(30),
          who_can_see: :all_user,
          published_at: Time.zone.now
        )
      end
    end
    User.all.each do |user|
      2.times do |i|
        Post.create!(
          title:"Friend only post"+FFaker::Lorem::sentence(4),
          author_id: user.id,
          content: FFaker::Lorem::sentence(30),
          who_can_see: :friend,
          published_at: Time.zone.now
        )
      end
    end
    User.all.each do |user|
      2.times do |i|
        Post.create!(
          title:"self only post"+FFaker::Lorem::sentence(4),
          author_id: user.id,
          content: FFaker::Lorem::sentence(30),
          who_can_see: :myself,
          published_at: Time.zone.now
        )
      end
    end
    puts "now have#{Post.count} post"
  end

  task fake_comment: :environment do   
    Comment.destroy_all
    Post.published.all_can_see.each do |post|
      users = User.all.sample(5)
      users.each do |user|
        post.comments.create(
          author_id: user.id,
          content: FFaker::Lorem::sentence(10)
        )
      end
    end
    puts "now have #{Comment.count} comments"
  end

  task fake_friend: :environment do 
    Friendship.destroy_all
    User.all.each do |user|
      User.all.sample(6).each do |friend_user|
        if user != friend_user
          if !user.is_friend?(friend_user)
            user.friendships.create!(friend_id:friend_user.id, is_friend: true)
            user.inverse_friendships.create!(user_id:friend_user.id, is_friend: true)
          end
        end
      end
    end
    puts "now have #{Friendship.count} friendships"
  end

  task fake_collect: :environment do
    Collect.destroy_all
    User.all.each do |user|
      posts = Post.published.all_can_see.sample(10)
      posts.each do |post|
        user.collect_posts<< post
      end
    end
    puts "now have #{Collect.count} collects"
  end
end