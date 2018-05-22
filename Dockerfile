FROM microsoft/dotnet:2.1.0-rc1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1.300-rc1-sdk AS build
WORKDIR /src
COPY aks-signalr-demo.csproj .
RUN dotnet restore -nowarn:msb3202,nu1503
COPY . .
RUN dotnet build aks-signalr-demo.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish aks-signalr-demo.csproj -c Release -o /app

FROM base AS final
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "aks-signalr-demo.dll"]