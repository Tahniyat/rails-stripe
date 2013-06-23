# Rails-Stripe README #

##Description:##

A project that integrate with Stripe API for credit card payments. 

##Setup:##

- git clone `https://github.com/Tahniyat/rails-stripe.git`
- Run `bundle install` to install all required gems.
- Run `rake db:create` to create database.
- Run `rake db:migrate` to create all required tables in database.
- Run `rake db:seed_fu` to insert basic and test data into tables.

All is set to use this project so start server by `rails s`

##Introduction:##

In this project, user can get subscripation from available list of plans. On selecting plan, user needs to provide Credit Card information and submit form. User will be subscribed for that plan and payment will be detected from credit card. 

Following are more details from technical perspective.

##Steps:##

- Get stripe account from [here](www.stripe.com)
- Stripe has two modes, test and live. Both have separate API keys. We are dealing with test mode. 
- add stripe gem into GemFile - `gem 'stripe'`
- run command: `bundle install`
- create a new file at `config/initializer/stripe.rb`. Here we need to add some configuration for stripe. 
- Get secert key and publishable keys from [here](https://manage.stripe.com/account/apikeys)
- Initialize these keys to `config/initializer/stripe.rb`
- Set `Stripe.api_key = {secret-key}` at `config/initializer/stripe.rb` - it can be initialize before sending request to stripe as well. All payments are recored against this api_key. 
- Now some work need to done on Stripe account. As we need to charge user on monthly basis so we need to setup this. We need to setup plans on stripe account. Go to [plans](https://manage.stripe.com/test/plans) and add some plans. Plan are added alongs ids. In our example, plans are created on stripe account as well as in database table `subscription_plans`. Plan IDs in table and stripe account should be same.   
- In these example, there are two controllers:
    - **Subscription_plans:** It shows all available plans like $25 for 25GB/month, $50 for 50GB/month
    - **Subscription:** It will allow user to subscripe against any available plan. 
- `Subscription/index.hml.erb` has form to submit credit card information. Here we need to do some configuration.
- Stripe provides javascript library that handles communication between user and stripe. Rails server doesn't need to do for that. 
- Add stripe's JS `https://js.stripe.com/v1/` in application layout before `application`
- Add PUBLISHABLE-KEY in meta tag as well - `<%= tag :meta, :name => 'stripe-key', :content => PUBLISHABLE_KEY %>` - It will be used by following javascript methods. 
- Form contains text field 'card_number', 'card_code', 'card_month' and 'card_year'. These all fields should have `name=nil` as these information will not send to rails server. Stripe will handle them internally. Form contains hidden field `stripe_card_token` that will be set by Javascript. 
- Following is javascript, which takes information from FORM, send to Stripe and get card-token to pass to rails. Here is `subscription.js.coffee`

        jQuery ->
            Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content')) 
		    subscription.setupForm()

    		subscription =
    			setupForm: ->	
    				$('#new_subscription').submit ->
    				  $('input[type=submit]').attr('disabled', true)
    				  if $('#card_number').length
    				    subscription.processCard()
    				    false
    				  else
    				    true
    		
    			processCard: ->
    				card =
    				  number: $('#card_number').val()
    				  cvc: $('#card_code').val()
    				  expMonth: $('#card_month').val()
    				  expYear: $('#card_year').val()
    				Stripe.createToken(card, subscription.handleStripeResponse)
    		
    			handleStripeResponse: (status, response) ->
    				if status == 200
    				  $('#subscription_stripe_card_token').val(response.id)
    				  $('#new_subscription')[0].submit()
    				else
    				  $('#stripe_error').text(response.error.message)
    				  $('input[type=submit]').attr('disabled', false) 


- On submit request post to rails server and controller `subscription` will handle it. 
- in controller, `Subscription` model is invoke and do following steps:
    - Model create a 'Stripe customer' against the card-token which was send by javascript. 
    - On customer creation, we send plan-id as well. So customer will be charged against that plan on monthly basis. 
    - Customer-id can saved in database as well. So in future if we want to charge the customer this ID can be used for that. 
- For testing purpose, few credit card numbers are declared by Stripe. Credit Card functionality is tested by that values only. List of test-able credit card number is available [here](https://stripe.com/docs/testing)


