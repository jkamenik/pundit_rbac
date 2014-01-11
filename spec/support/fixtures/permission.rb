class Permission
  attr_accessor :action, :resource, :allowed
  alias_method :allowed?, :allowed
  
  def initialize(action,resource,allow)
    @action   = action
    @resource = resource
    @allowed  = allow
  end
  
  def is_for?(a,r)
    action == a && resource == r
  end
end