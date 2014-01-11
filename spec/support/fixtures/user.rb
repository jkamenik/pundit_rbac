class User
  attr_accessor :roles
  
  def initialize(roles=[])
    @roles = roles
  end
end