# Access Control
# If a method is private, it may be called only within the context of the calling object--it is never possible to access another object's methods directly, even if the object is of the same class as the caller.
class MyClass
  def method1 # default is 'public'
    # ...
  end
  protected
  def method2
    # ...
  end
  private
  def method3
    # ...
  end
  public
  def method4
    # ...
  end
end

# Alternatively, you can set access levels od named methods by listing them as arguments to the access control functions.

class MyClass2
  def method1
    # ...
  end
  def method2
    # ...
  end
  def method3
    # ...
  end
  def method4
    # ...
  end
  public :method1, :method4
  protected :method2
  private :method3
end

# It's time for some examples.
class Accounts
  def initialize(checking, savings)
    @checking = checking
    @savings = savings
  end
  private
  def debit(account, amount)
    account.balance -= amount
  end
  def credit(account, amount)
    account.balance += amount
  end
  public
  def transfer_to_savings(amount)
    debit(@checking, amount)
    credit(@savings, amount)
  end
end

class Account
  attr_reader :balance
  protected :balance
  def greater_balance_than(other)
    return @balance > other.balance
  end
end
























