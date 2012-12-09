class User < ActiveRecord::Base
  # Use built-in rails support for password protection
  has_secure_password
  
  # Specify fields that can be accessible through mass assignment (not password_digest)
  attr_accessible :username, :first_name, :last_name, :role, :password, :password_confirmation
  
  # Relationships
  # -----------------------------
  has_many :notes

  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :first_name, :last_name, :username 
  validates_uniqueness_of :username
  validates_presence_of :password, :on => :create 
  validates_presence_of :password_confirmation, :on => :create 
  validates_confirmation_of :password, :message => "does not match"
  validates_length_of :password, :minimum => 4, :message => "must be at least 4 characters long", :allow_blank => true
  validates_inclusion_of :role, :in => %w( vet assistant ), :message => "is not recognized in the system"
  
  # Other methods
  scope :alphabetical, order('last_name, first_name')
  scope :active, where('active = ?', true)

  # -----------------------------  
  def proper_name
    first_name + " " + last_name
  end
  
  def name
    last_name + ", " + first_name
  end

  # for use in authorizing with CanCan
  ROLES = [['Vet', :vet],['Assistant', :assistant]]

  def role?(authorized_role)
    return false if role.nil?
    role.downcase.to_sym == authorized_role
  end

  
  # login by username
  def self.authenticate(username, password)
    find_by_username(username).try(:authenticate, password)
  end
end
