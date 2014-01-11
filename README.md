# PunditRbac

[![Build Status](https://travis-ci.org/jkamenik/pundit_rbac.png?branch=master)](https://travis-ci.org/jkamenik/pundit_rbac)

Adds simple RBAC support to Pundit.  See [Pundit](https://github.com/elabs/pundit) for full details on using it to create authorization in ruby apps.

## Installation

Add this line to your application's Gemfile:

    gem 'pundit_rbac'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pundit_rbac

## Policies

A policy maps a User/Actor to a Resource via an action and defines if that combination is allowed or denied.

```
User -> Action -> Resource
          |
          V
        Policy
          |
          V
      Yes or no?
```

With Pundit as well as PunditRbac everything are raw ruby objects.  The end goal of a policy is always to affirmitately allow or deny access to a resource.

## RBAC

Role Based Access Control (RBAC) attempts to make permissions configurable by adding a Role/Permissions filter to the policy.  Roles and Permissions are often serialized in some way and can be changed at runtime.

```
User -------> Roles --------> Permissions --> Resource
     has many       has many              +-> Action
                                          +-> Answer (Yes or No)
```

PunditRbac aims to automate the process of calculating the policy but makes no assertions about the User or Resource being acted upon.  So long as they follow the correct protocol everything will work.

## RbacPolicy

```ruby
class ApplicationPolicy < PunditRbac::RbacPolicy
  # override show to always allow it
  def show?
      true
  end
end
```

Any object that inherits from `PunditRbac::RbacPolicy` will follow the RbacPolicy.  Basically it uses `method_missing` to call `allowed?`.  If you don't want to follow RBAC you are not forced to, simply create a method with the policy behavior you want.

## User/Actor

```ruby
class User
  def roles
    # load by roles from somewhere
  end
end
```

A user/actor just has to reply to the `roles` message with an array of Role objects.

## Role

```ruby
class Role
  def permissions_for(action,resource)
    # action is a symbol - :show?
    # resource is a string - "User"
  end
end
```

A role has to reply to the `permissions_for` message and return a list of boolean values.  If there are no valid permissions return either an empty array or `nil`.

## Permission

We make no assumptions about how Permissions are stored or returned.  We simply ask the Role to return us all valid answers that permissions provide.  This allows you to serialize your permissons on any way you see fit and abstract that away in the Role class.


## Putting it all together

Lets assume your that users and roles are stored in a database but permissions in a YAML file.


```yaml permissions.yml
admin:
    User:
        show?:   true
        update?: true
user:
    User:
        show?:   true
        update?: false
```

```ruby
class ApplicationPolicy < PunditRbac::RbacPolicy
end

class UserPolicy < ApplicationPolicy
    def update?
        return true if user == resourc
        allowed? :update?
    end
end
```

```ruby
class User < ActiveRecord::Base
    has_many :roles
end

class Role < ActiveRecord::Base
    attr_accessor :role_name
    
    def permissions_for(action,resource)
        Array(
            yaml[role_name][resource.to_s][action.to_s]
        )
    rescue
        []
    end
end
```

`UserPolicy` is an RBAC policy and overrides the `update?` permission to ensure that users can update themselves.

`Role` loads the yaml file and just accesses keys in the nested hash.  If it fails it returns an empty permission set.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
