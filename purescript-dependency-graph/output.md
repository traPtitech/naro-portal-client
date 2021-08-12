```mermaid
flowchart 
Main[Main]
subgraph Kuragate_subgraph [Kuragate]
Kuragate[/Kuragate/]
Kuragate.Components.Router[Router]
Kuragate.Store[Store]
subgraph Kuragate.Classes_subgraph [Classes]
Kuragate.Classes[/Classes/]
Kuragate.Classes.LoginHandler[LoginHandler]
Kuragate.Classes.MessagesHandler[MessagesHandler]
Kuragate.Classes.NavigationHandler[NavigationHandler]
Kuragate.Classes.RegistrationHandler[RegistrationHandler]
end
subgraph Kuragate.Components_subgraph [Components]
Kuragate.Components[/Components/]
Kuragate.Components.Home[Home]
Kuragate.Components.Login[Login]
Kuragate.Components.Register[Register]
Kuragate.Components.Settings[Settings]
end
subgraph Kuragate.Data_subgraph [Data]
Kuragate.Data[/Data/]
Kuragate.Data.Message[Message]
Kuragate.Data.Page[Page]
Kuragate.Data.Profile[Profile]
end
end
Main --> Kuragate.Components.Router
Main --> Kuragate.Store
Kuragate.Components.Router --> Kuragate.Classes.LoginHandler
Kuragate.Components.Router --> Kuragate.Classes.MessagesHandler
Kuragate.Components.Router --> Kuragate.Classes.NavigationHandler
Kuragate.Components.Router --> Kuragate.Classes.RegistrationHandler
Kuragate.Components.Router --> Kuragate.Components.Home
Kuragate.Components.Router --> Kuragate.Components.Login
Kuragate.Components.Router --> Kuragate.Components.Register
Kuragate.Components.Router --> Kuragate.Components.Settings
Kuragate.Components.Router --> Kuragate.Data.Page
Kuragate.Components.Router --> Kuragate.Store
Kuragate.Store --> Kuragate.Data.Profile
Kuragate.Classes.LoginHandler --> Kuragate.Data.Profile
Kuragate.Classes.MessagesHandler --> Kuragate.Data.Message
Kuragate.Classes.NavigationHandler --> Kuragate.Data.Page
Kuragate.Components.Home --> Kuragate.Classes.LoginHandler
Kuragate.Components.Home --> Kuragate.Classes.MessagesHandler
Kuragate.Components.Home --> Kuragate.Data.Message
Kuragate.Components.Home --> Kuragate.Data.Profile
Kuragate.Components.Home --> Kuragate.Store
Kuragate.Components.Login --> Kuragate.Classes.LoginHandler
Kuragate.Components.Login --> Kuragate.Classes.NavigationHandler
Kuragate.Components.Login --> Kuragate.Data.Page
Kuragate.Components.Login --> Kuragate.Store
Kuragate.Components.Register --> Kuragate.Classes.NavigationHandler
Kuragate.Components.Register --> Kuragate.Classes.RegistrationHandler
Kuragate.Components.Register --> Kuragate.Data.Page
Kuragate.Components.Settings --> Kuragate.Classes.LoginHandler
Kuragate.Components.Settings --> Kuragate.Classes.NavigationHandler
Kuragate.Components.Settings --> Kuragate.Data.Page
Kuragate.Components.Settings --> Kuragate.Store
```