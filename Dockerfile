#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["third-docker.csproj", "."]
RUN dotnet restore "./third-docker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "third-docker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "third-docker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "third-docker.dll"]