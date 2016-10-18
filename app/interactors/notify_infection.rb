class NotifyInfection
  include Interactor

  # params: survivor(Survivor), infected(Survivor)
  def call

    can?

    register_infection

    flag_as_infected
  end

  def register_infection
    infection_notification = InfectionNotification.new(survivor: context.survivor, infected: context.infected)

    if !infection_notification.save
      context.fail!(error: infection_notification.errors)
    end
  end

  def flag_as_infected
    if context.infected.received_infection_notifications.count >= 3
      unless context.infected.update(infected: true)
        context.fail!(error: context.infected.errors)
      end
    end
  end

  def can?
    if context.infected.infected?
      context.fail!(error: 'This survivor is already flagged as infected! Thank you for reporting')
    end

    if InfectionNotification.find_by(survivor_id: context.survivor.id, infected_id: context.infected.id)
      context.fail!(error: 'You have already notified this infection. Thanks')
    end
  end

end