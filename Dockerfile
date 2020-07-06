FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /Testing

# Copy csproj and restore as distinct layers
COPY myWebApp/*.csproj ./

RUN dotnet restore

# Copy everything else and build
COPY myWebApp ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /Testing

COPY --from=build-env /Testing/out .

ENTRYPOINT ["dotnet", "myWebApp.dll"]