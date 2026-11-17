# STAGE 1: Build & Publish the .NET Application
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

# Set the working directory to src
WORKDIR /src

# Copy the solution file from host computer to the container
COPY *.sln .

# Copy the specific project file from the host computer into /src/Todo
COPY Todo/Todo.csproj Todo/

# Restore NuGet packages
RUN dotnet restore Todo/Todo.csproj 

# Copy the rest of the application source code into /src/Todo
COPY Todo/. Todo/

WORKDIR /src/Todo

# Compile and Publish in Release mode
RUN dotnet publish -c Release -o /app --no-restore

# STAGE 2: Runtime Image
FROM mcr.microsoft.com/dotnet/aspnet:10.0

WORKDIR /app

ENV ASPNETCORE_HTTP_PORTS=8080 

EXPOSE 8080

# Copy the compiled application files from the build stage container into this runtime container
COPY --from=build /app .

ENTRYPOINT ["dotnet", "Todo.dll"]
