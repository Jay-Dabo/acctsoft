class Reconciliation < ActiveRecord::Base
  belongs_to :account
  has_many :txn_accounts, :dependent => :nullify

  validates_presence_of :account_id, :reconciled_at, :statement_on
  validates_uniqueness_of :statement_on, :scope => :account_id

  def account_no
    self.account ? self.account.no : nil
  end

  def account_no=(value)
    self.account = Account.find_by_no(value)
  end

  def find_potential_transactions
    return [] if self.new_record?
    self.account.txn_parts.find(:all, :conditions => ['reconciliation_id IS NULL'])
  end

  def amount_dt
    self.txn_accounts.sum(:amount_dt_cents).to_money / 100.0
  end

  def amount_ct
    self.txn_accounts.sum(:amount_ct_cents).to_money / 100.0
  end
end
