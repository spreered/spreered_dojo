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
      post_count = rand(3..6)
      post_count.times do |i|
        Post.create!(
          title:FFaker::Lorem::sentence(4),
          author_id: user.id,
          content: FFaker::Lorem::sentence(30),
          who_can_see: :all_user,
          published_at: Time.zone.now
        )
      end
      puts "user #{user.name} get #{post_count} public posts"
    end
    User.all.each do |user|
      post_count = rand(1..3)
      post_count.times do |i|
        Post.create!(
          title:"Friend only post"+FFaker::Lorem::sentence(4),
          author_id: user.id,
          content: FFaker::Lorem::sentence(30),
          who_can_see: :friend,
          published_at: Time.zone.now
        )
      end
      puts "user #{user.name} get #{post_count} friend only posts"
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
      puts "user #{user.name} get 2 self only posts"
    end
    puts "now have#{Post.count} post"
  end

  task fake_comment: :environment do   
    Comment.destroy_all
    Post.published.all_user.each do |post|
      replies_num = rand(3..10)
      users = User.all.sample(replies_num)
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
      posts = Post.published.all_user.sample(10)
      posts.each do |post|
        user.collect_posts<< post
      end
    end
    puts "now have #{Collect.count} collects"
  end

  task fake_categories: :environment do
    categories_list = [
      'Sport',
      'Programming',
      'Movie',
      'Literature',
      'Comics',
      'political'
    ]
    Category.destroy_all
    categories_list.each do |category_name|
      category = Category.create!(name: category_name)
      puts "create category #{category.name}"
    end
    Post.find_each do |post|
      category = Category.all.sample
      post.categories <<  category
      puts "post #{post.title} add #{category.name} category"
    end
  end

  task update_replies_count: :environment do
    Post.all.each do |post|
      post.replies_count = post.comments.count
      puts "replies_count = #{post.replies_count}, comments count = #{post.comments.count}"
      post.save
    end
  end

  task update_chatterbox_count: :environment do
    User.all.each do |user|
      count = 0
      user.posts.each do |post|
        count += post.replies_count
      end
      user.update(chatterbox_count: count)
      puts "user : #{user.name} chatterbox_count: #{user.chatterbox_count}"
    end
  end

  task fake_all_production: :environment do
    system 'bin/rake RAILS_ENV=production dev:fake_user'  
    system 'bin/rake RAILS_ENV=production dev:fake_post'  
    system 'bin/rake RAILS_ENV=production dev:fake_comment'  
    system 'bin/rake RAILS_ENV=production dev:fake_friend'   
    system 'bin/rake RAILS_ENV=production dev:fake_collect'   
    system 'bin/rake RAILS_ENV=production dev:fake_categories'   
  end
  task fake_all: :environment do
    system 'rails dev:fake_user'  
    system 'rails dev:fake_post'  
    system 'rails dev:fake_comment'  
    system 'rails dev:fake_friend'   
    system 'rails dev:fake_collect'   
    system 'rails dev:fake_categories'   
  end
end