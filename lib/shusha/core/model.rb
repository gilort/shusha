class ActiveRecord::Base
  def draw
    #just for indexing
  end

  private
  def context
    Shusha.context
  end

  def window
    context['shusha/windows_manager'].current_window
  end

  def config
    context['shusha/configuration']
  end

  def assets
    context['shusha/asset']
  end

  def multiplier
    config.cell_size
  end
end