class Transaction < ApplicationRecord
  belongs_to :user
  enum status: { pending: 0, completed: 1, failed: 2 }

  def self.deposit(user, amount, currency)
    charge = CoinbaseCommerce::Charge.create(
      name: "Deposit to account",
      description: "Deposit to user account",
      local_price: {
        amount: amount,
        currency: currency
      },
      pricing_type: "fixed_price",
      metadata: {
        user_id: user.id
      }
    )
    Transaction.create!(
      user: user,
      charge_id: charge.id,
      amount: amount,
      currency: currency,
      status: :pending
    )
  end

  def self.withdraw(user, amount, currency)
    withdrawal = CoinbaseCommerce::Payout.create(
      amount: {
        amount: amount,
        currency: currency
      },
      metadata: {
        user_id: user.id
      }
    )
    Transaction.create!(
      user: user,
      charge_id: withdrawal.id,
      amount: amount,
      currency: currency,
      status: :pending
    )
  end

  def complete!
    self.update(status: :completed)
  end

  def fail!
    self.update(status: :failed)
  end
end
