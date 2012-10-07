Auditorium::Application.routes.draw do

  scope "(:locale)", :locale => /en|de/ do
    resources :feedbacks
    post 'feedback/:id/mark_as_read' => 'feedback#mark_as_read', :as => :mark_feedback_as_read


    mathjax 'mathjax'
    
    resources :email_settings

    match "ajax/courses"
    match "ajax/lectures"
    match "ajax/chairs"

    match 'intro', :to => 'landing_page#index'
    match 'home', :to => 'home#index'
    match 'my_faculties', :to => 'my_faculties#index'
    match 'permission_denied', :to => 'applications#permission_denied', :as => :permission_denied

    resources :notifications
    
    resources :faculties
    
    resources :terms
    match 'courses/search', to: 'terms#search_courses', as: :search_courses
    match 'my_courses/search', to: 'terms#search_courses', as: :search_my_courses
    match 'terms/:id/search', to: 'terms#search_courses', as: :search_courses_in_term
    match 'lectures/search', to: 'lectures#search', as: :search_lectures

    controller :search do
      match 'search' => :index, as: :search
    end

    devise_for :users, :controllers => { :confirmations => "users/confirmations", :sessions => "users/sessions", :registrations => "users/registrations" }
    match 'users/moderation' => 'users#moderation', :as => :users_moderation
    match 'users/moderation/search', to: 'users#search', as: :search_users
    resources :users
    match 'users/:id/questions' => 'users#questions', :as => :users_questions
    match 'users/:id/answers' => 'users#answers', :as => :users_answers
    match 'users/:id/confirm' => 'users#confirm', :as => :confirm_user
    post 'notifications/mark_all_as_read' => 'notifications#mark_all_as_read', :as => :mark_all_as_read
    

    resources :courses
    match 'courses/:id/manage_users', :to => 'courses#manage_users'
    match 'courses/<search', :to => 'courses#search'
    match 'courses/:id/following', :to => 'courses#following', as: :follow_course
    match 'courses/:id/approve', :to => 'courses#approve', :as => :approve_course
    match 'courses/:id/unfollow', :to => 'courses#following', :unfollow => 'true'
    match 'posts/:id/rate', :to => 'posts#rate', :as => :rate_post
    match 'posts/:id/answered', :to => 'posts#answered', :as => :answered_post
    
    match 'posts/:parent_id/answering', :to => 'posts#answering'
    match 'posts/:parent_id/commenting', :to => 'posts#commenting'

    resources :reports

    match '/reports/:id/mark_read', :to => 'reports#mark_read', :as => 'mark_report_as_read'

    resources :course_memberships
    match "my_courses", :to => "course_memberships#index"

    match 'chairs/search', to: 'chairs#search', as: :search_chairs
    resources :chairs
    

    resources :posts do
      match :autocomplete_courses_name, :on => :collection
    end

    resources :reports

    resources :periods

    resources :institutes

    resources :events

    resources :lectures

    match '/:locale', :to => 'landing_page#index'
    root to: "landing_page#index"
  end
end
