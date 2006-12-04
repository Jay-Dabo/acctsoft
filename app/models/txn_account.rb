class TxnAccount < ActiveRecord::Base
  acts_as_list :scope => :txn_id

  belongs_to :txn
  belongs_to :account
  belongs_to :reconciliation
  validates_presence_of :account_id

  composed_of :amount_dt, :class_name => 'Money',
      :mapping => [%w(amount_dt_cents cents), %w(amount_dt_currency currency)]
  composed_of :amount_ct, :class_name => 'Money',
      :mapping => [%w(amount_ct_cents cents), %w(amount_ct_currency currency)]

  before_validation DebitCreditNormalizer.new
  validate :non_nil_volume

  def no
    self.account.no
  end

  def no=(account_no)
    self.account = Account.find_by_no(account_no)
  end

  def name
    self.account.name
  end

  def debit=(amount)
    self.amount_dt = amount.to_money
  end

  def debit
    self.amount_dt
  end

  def credit=(amount)
    self.amount_ct = amount.to_money
  end

  def credit
    self.amount_ct
  end

  def reconcile!(reconciliation)
    self.reconciliation = reconciliation
    self.save!
  end

  def unconcile!
    self.reconciliation = nil
    self.save!
  end

  protected
  def non_nil_volume
    return unless (self.amount_dt - self.amount_ct).zero?
    self.errors.add_to_base('Le volume ne doit pas être nul')
  end
end
