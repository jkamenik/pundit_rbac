require 'spec_helper'

describe PunditRbac::RbacPolicy do
  let(:policy)   { PunditRbac::RbacPolicy.new(user, resource) }
  let(:user)     { User.new }
  let(:resource) { Resource.new }
  
  context '.method_missing' do
    it 'sends treats any unknown message as an action' do
      expect(policy).to receive(:allowed?).with(:show?)
      
      policy.show?
    end
    
    it 'raises an error for non-question functions' do
      expect {policy.show}.to raise_error NoMethodError
    end
  end
  
  context '.allowed?' do
    let(:user)              { User.new [role] }
    let(:role)              { Role.new [show_permission, update_permission] }
    let(:show_permission)   { Permission.new :show?,   resource, true }
    let(:update_permission) { Permission.new :update?, resource, false }
    
    it 'calls `roles` on the user object' do
      expect(user).to receive(:roles).and_return []
      
      policy.allowed?(:show?)
    end
    
    it 'checks each role for permissions matching the resource and action' do
      expect(role).to receive(:permissions_for).with(:show?, resource)
      
      policy.allowed?(:show?)
    end
    
    it 'returns true if the user is able to perform the action' do
      expect(policy.allowed?(:show?)).to be_true
    end
    
    it 'return false if the user has no permissions defined for the resource/action' do
      expect(policy.allowed?(:foo?)).to be_false
    end
    
    it 'returns false if the user is not allowed to perform the action' do
      expect(policy.allowed?(:update?)).to be_false
    end
    
    it 'returns false if user is both able and unable to do something' do
      perm = show_permission.clone
      perm.allowed = false
      role.permissions << perm
      
      expect(policy.allowed?(:show?)).to be_false
    end
  end
end