﻿ARG runtime_base_tag=2.1-aspnetcore-runtime
ARG build_base_tag=2.1-sdk

FROM microsoft/dotnet:${build_base_tag} AS build
WORKDIR /app

COPY opcpublisher/*.csproj ./opcpublisher/
WORKDIR /app/opcpublisher
RUN dotnet restore

# copy and publish app
WORKDIR /app
COPY opcpublisher/. ./opcpublisher/
WORKDIR /app/opcpublisher
RUN dotnet publish -c Release -o out

# start it up
FROM microsoft/dotnet:${runtime_base_tag} AS runtime
WORKDIR /app
COPY --from=build /app/opcpublisher/out ./
WORKDIR /appdata
ENTRYPOINT ["dotnet", "/app/opcpublisher.dll"]