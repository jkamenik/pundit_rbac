module PunditRbac
  class RbacPolicy
    attr_reader :user, :record

    def initialize(user, record)
      @user = user
      @record = record
    end
    
    def method_missing(method,*args,&block)
      if method.to_s =~ /\?$/
        allowed?(method)
      else
        super
      end
    end
    
    def allowed?(action)
      permissions(action).reduce(:&)
    end
    
    protected
    
    def permissions(action)
      user.roles.inject([]) do |array,role|
        array.concat Array(role.permissions_for(action,record))
        array
      end.compact
    end
  end
end