class ConfirmationsController < DeviseTokenAuth::ConfirmationsController
  def success
    # Decode the redirect URL
  end

  def show
    # Decode the URL
    redirect_url = CGI.unescape(params[:redirect_url])
    # Retrieve the user based on the confirmation token in the URL
    @resource = resource_class.confirm_by_token(params[:confirmation_token])
    # Check if the user has already confirmed their email address
    if @resource.errors.empty?
      # Display a success message to the user
      flash[:notice] = 'Email address confirmed. You can now sign in.'
      # Redirect to the decoded URL
      redirect_to redirect_url
    else
      # Display an error message to the user
      flash[:alert] = 'Confirmation failed. Please check the URL and try again.'
      # Redirect to the error URL
      redirect_to confirmation_error_url
    end
  end

  def confirm
    @resource = resource_class.confirm_by_token(params[:confirmation_token])

    if @resource.errors.empty?
      @resource.update_attribute(:confirmed_at, Time.now)

      sign_in(:user, @resource)

      redirect_to CGI.unescape(params[:redirect_url])
    else
      redirect_to confirmation_error_url
    end
  end

  private

  def success_url
    '/http://localhost:3000/confirmation_success?account_confirmation_success=true'
  end

  def confirmation_error_url
    '/confirmation_error'
  end
end
