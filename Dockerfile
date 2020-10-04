#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
#mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim    mcr.microsoft.com/dotnet/core/sdk:3.1-buster
FROM registry.cn-hangzhou.aliyuncs.com/luesheng/aspnet.core:3.1.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM registry.cn-hangzhou.aliyuncs.com/luesheng/aspnet.core.sdk:3.1.0 AS build
WORKDIR /src
COPY ["aspNetCore.csproj", "aspNetCore/"]
RUN dotnet restore "aspNetCore/aspNetCore.csproj"
COPY . aspNetCore/
WORKDIR "/src/aspNetCore"
RUN dotnet build "aspNetCore.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "aspNetCore.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aspNetCore.dll"]