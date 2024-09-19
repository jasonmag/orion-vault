# app/models/concerns/soft_deletable.rb
module SoftDeletable
  extend ActiveSupport::Concern

  included do
    # Scope to only include records that are not soft-deleted
    default_scope { where(deleted_at: nil) }
  end

  # Soft-delete method
  def soft_delete
    update(deleted_at: Time.current)
  end

  # Restore a soft-deleted record
  def restore
    update(deleted_at: nil)
  end

  # Check if the record is soft-deleted
  def deleted?
    deleted_at.present?
  end

  # Override the destroy method to perform a soft delete
  def destroy
    soft_delete
  end

  # Ensure destroy! still works for permanent deletion if needed
  def destroy!
    super
  end

  # Class method to return all records, including soft-deleted ones
  class_methods do
    def with_deleted
      unscoped.all
    end
  end
end
