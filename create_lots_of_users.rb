user_list = [
    {email: 'ben@theorbitalmechanics.com',
                password: 'VSkI3n&r0Q9k2XFZGxUi',
                subscribed: false,
                admin: true},
    {email: 'subscriber1@fake.com', subscribed: true},
    {email: 'subscriber2@fake.com', subscribed: true},
    {email: 'subscriber3@fake.com', subscribed: true},
    {email: 'subscriber4@fake.com', subscribed: true},
    {email: 'subscriber5@fake.com', subscribed: true},
    {email: 'subscriber6@fake.com', subscribed: true},
    {email: 'subscriber7@fake.com', subscribed: true},
    {email: 'subscriber8@fake.com', subscribed: true},
    {email: 'subscriber9@fake.com', subscribed: true},
    {email: 'nonsubscriber1@fake.com', subscribed: false},
    {email: 'nonsubscriber2@fake.com', subscribed: false},
    {email: 'nonsubscriber3@fake.com', subscribed: false},
    {email: 'nonsubscriber4@fake.com', subscribed: false}
]
for params in user_list do
    User.new(params).save
end