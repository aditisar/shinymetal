# Objectify requests to the API in the Api Controller
class EndpointRequest
  # These values will be immediately removed from the options hash.
  # FIXME Why?
  BLACKLIST = %w[format controller action endpoint]
  
  # @return [String] The resource passed into the URL.
  attr_reader :resource
  # @return [Hash] The paramaters passed into the URL, with blacklist values removed.
  attr_reader :options
  
  # Initialize an EndpontRequest.
  #
  # @param user_key [UserKey] User key with the Gen API Key that matches the one passed in earlier.
  # @param resource [String] Resource that is being requested by the user.
  # @param options [Hash] The response options that the user passed in,
  #   not including the endpoint itself. For example, { "page" => "1", "status" => "active" }.
  # @return [EndpointRequest]
  def initialize(user_key, resource, options)
    @user_key = user_key
    # It doesn't matter if the resource passed in exists or not; that will already cause errors in the response.
    @resource = resource
    @options = options.reject{ |k,v| BLACKLIST.include?(k) }
  end
  
  # Determines if the given user key is allowed to request the paramaters passed in.
  # Only the restrictions of one whitelist needs to be included for the request to be allowed.
  #
  # @return [Boolean] True, iff these options are allowed for this user_key.
  def valid?
    filter_group_list = @user_key.whitelists.restrict_to(@resource).to_a.map{|w| w.filters.to_a}
    # If the key has no whitelists at all, the key has unrestricted filter access.
    # (If the key has no columns, the key has no access at all, but we check for that in the controller.)
    return true if filter_group_list.empty?
    # Map the filters for each individual whitelist into a list to be checked.
    for filter_group in filter_group_list
      return true if matches_options?(filter_group)
    end
    # No filters were matched, so check for organizations instead.
    return has_valid_organization_id?
  end
  
  # Determines if the paramaters passed contain the values of a given list of filters.
  #
  # @param filter_group [Array<Filter>] List of filter objects, already mapped earlier from one of the whitelists.
  # @return [Boolean] Whether or not the given filter group contains this list of filters.
  private
  def matches_options?(filter_group)
    for filter in filter_group
      if @options[filter.filter_name] != filter.filter_value
	return false
      end
    end
    return true
  end
  
  def has_valid_organization_id?
    return @user_key.organizations.active.map{|o| o.external_id.to_s}.include?(@options["organizationId"].to_s)
  end
end