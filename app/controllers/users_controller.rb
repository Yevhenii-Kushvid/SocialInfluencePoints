class UsersController < ApplicationController

  def index
    @user_influence_points = []

    # Базовые очки влияния
    User.all.each{ |user|
      @user_points = (Post.where(user_id: 1).count * 2 + Post.where(user_id: 1).inject(0) {|result, post| result + post.likes })
                      #Количество постов                  Количество постов
      User.all.each{ |user_2|
        if is_friend?(user.id, user_2.id)
          @user_points += 10
        else
          if is_subscriber?(user.id, user_2.id)
            @user_points += 5
          end
        end
      }
      @user_influence_points << [user, @user_points]
    }

    # Дополнительные очки влияния
    @user_influence_points = @user_influence_points.inject([]) {|result, user_1|

      @additional_points = 0

      @user_influence_points.each{|user, points|
        if is_friend?(user_1[0].id, user.id)
          @additional_points += points.to_f / 5
        else
          if is_subscriber?(user_1[0].id, user.id)
            @additional_points += points.to_f / 10
          end
        end
      }

      result << [user_1[0], user_1[1] + @additional_points]
    }

    @user_influence_points.sort! {|x, y| y[1] <=> x[1] }
  end

  private

  def is_friend?(user_1, user_2)
    !FriendList.where(friend_of_id: user_1, user_id: user_2).empty? && !FriendList.where(friend_of_id: user_2, user_id: user_1).empty?
  end

  def is_subscriber?(user_1, user_2)
    !FriendList.where(friend_of_id: user_1, user_id: user_2).empty? && FriendList.where(friend_of_id: user_2, user_id: user_1).empty?
  end

end
