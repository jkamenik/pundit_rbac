class Role
  attr_accessor :permissions
  
  def initialize(permissions=[])
    @permissions = permissions
  end
  
  def permissions_for(action,resource)
    permissions.inject([]) do |array,perm|
      array.push perm.allowed? if perm.is_for?(action,resource)
      array
    end
  end
end