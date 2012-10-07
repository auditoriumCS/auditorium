Auditorium::Application.routes.draw do
  scope "(:locale)", :locale => /en|de/ do
    resources :feedback
    match '/feedback', :to => 'feedback#index', :as => :feedbacks
    post 'feedback/:id/mark_as_read' => 'feedback#mark_as_read', :as => :mark_feedback_as_read


    mathjax 'mathjax'
    
    resources :email_settings

    match "/ajax/courses"
    match "/ajax/lectures"

    match '/intro', :to => 'landing_page#index'
    match '/home', :to => 'home#index'
    match '/permission_denied', :to => 'applications#permission_denied', :as => :permission_denied

    resources :notifications
    
    resources :faculties
    
    controller :search do
      match '/search' => :index, as: :search
    end

    devise_for :users, :controllers => { :confirmations => "users/confirmations", :sessions => "users/sessions", :registrations => "users/registrations" }
    match '/users/moderation' => 'users#moderation', :as => :users_moderation
    
    resources :users
    match '/users/:id/questions' => 'users#questions', :as => :users_questions
    match '/users/:id/answers' => 'users#answers', :as => :users_answers
    match '/users/:id/confirm' => 'users#confirm', :as => :confirm_user
    post '/:locale/notifications/mark_all_as_read' => 'notifications#mark_all_as_read', :as => :mark_all_as_read
    
    resources :lectures

    resources :courses
    match '/courses/:id/manage_users', :to => 'courses#manage_users'
    match '/courses/<search', :to => 'courses#search'
    match '/courses/:id/following', :to => 'courses#following'
    match '/courses/:id/approve', :to => 'courses#approve', :as => :approve_course
    match '/courses/:id/unfollow', :to => 'courses#following', :unfollow => 'true'
    match '/posts/:id/rate', :to => 'posts#rate', :as => :rate_post
    match '/posts/:id/answered', :to => 'posts#answered', :as => :answered_post
    
    match '/posts/:parent_id/answering', :to => 'posts#answering'
    match '/posts/:parent_id/commenting', :to => 'posts#commenting'

    resources :reports

    match '/reports/:id/mark_read', :to => 'reports#mark_read', :as => 'mark_report_as_read'

    resources :course_memberships
    match "/my_courses", :to => "course_memberships#index"

    resources :chairs

    resources :posts do
      match :autocomplete_courses_name, :on => :collection
    end

    resources :reports
    resources :terms
    resources :institutes
    
    match '/:locale' => 'landing_page#index'
    root :to => 'landing_page#index'
  end
end
