{{- /* =================================================================
     index.html.tpl
     Rendered by consul-template.
     Every {{ key "..." }} call is a live watch on the Consul KV store.
     When any watched key changes, consul-template re-renders this file
     and nginx immediately serves the updated content.
     ================================================================= */ -}}

{{- $title        := keyOrDefault "nginx/config/site_title"    "Consul Demo" -}}
{{- $company      := keyOrDefault "nginx/config/company_name"  "Learning Lab" -}}
{{- $env          := keyOrDefault "nginx/config/environment"   "Dev" -}}
{{- $version      := keyOrDefault "nginx/config/version"       "0.0.0" -}}
{{- $color        := keyOrDefault "nginx/config/primary_color" "#6C4FBB" -}}
{{- $footer       := keyOrDefault "nginx/config/footer_text"   "" -}}

{{- $nodeName     := env "NODE_NAME" -}}
{{- $nodePort     := env "NODE_PORT" -}}
{{- $nodeMsg      := keyOrDefault (printf "nginx/nodes/%s/message" $nodeName) "No message set for this node." -}}

{{- $showCluster  := keyOrDefault "nginx/features/show_cluster_info"  "true" -}}
{{- $maintenance  := keyOrDefault "nginx/features/maintenance_mode"    "false" -}}
{{- $banner       := keyOrDefault "nginx/features/banner_message"      "" -}}

{{- $heroHeading  := keyOrDefault "nginx/content/hero_heading" "Consul Demo" -}}
{{- $heroBody     := keyOrDefault "nginx/content/hero_body"    "" -}}

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>{{ $title }} — {{ $nodeName }}</title>
  <style>
    :root {
      --primary:  {{ $color }};
      --primary-dark: color-mix(in srgb, {{ $color }} 70%, black);
      --bg:       #0f0f1a;
      --surface:  #1a1a2e;
      --surface2: #16213e;
      --text:     #e0e0f0;
      --muted:    #8888aa;
      --green:    #00c896;
      --yellow:   #ffd166;
      --red:      #ef476f;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Segoe UI', system-ui, sans-serif;
      background: var(--bg);
      color: var(--text);
      min-height: 100vh;
    }

    /* ---- TOP BAR ---- */
    header {
      background: var(--primary);
      padding: 0.75rem 2rem;
      display: flex;
      align-items: center;
      gap: 1rem;
      box-shadow: 0 2px 12px rgba(0,0,0,0.5);
    }
    header .logo { font-size: 1.5rem; font-weight: 800; letter-spacing: -0.5px; color: #fff; }
    header .logo span { opacity: 0.7; font-weight: 400; }
    header .badge {
      margin-left: auto;
      background: rgba(255,255,255,0.2);
      color: #fff;
      padding: 0.2rem 0.7rem;
      border-radius: 20px;
      font-size: 0.75rem;
      font-weight: 600;
    }

    /* ---- MAINTENANCE BANNER ---- */
    {{ if eq $maintenance "true" }}
    .maintenance-bar {
      background: var(--red);
      color: #fff;
      text-align: center;
      padding: 0.6rem;
      font-weight: 600;
    }
    {{ end }}

    /* ---- INFO BANNER ---- */
    .banner {
      background: var(--surface2);
      border-left: 4px solid var(--yellow);
      padding: 0.75rem 2rem;
      font-size: 0.9rem;
      color: var(--yellow);
    }

    main { max-width: 960px; margin: 0 auto; padding: 2rem 1.5rem; }

    /* ---- NODE BADGE ---- */
    .node-card {
      background: linear-gradient(135deg, var(--primary), var(--primary-dark));
      border-radius: 12px;
      padding: 1.5rem 2rem;
      margin-bottom: 2rem;
      display: flex;
      align-items: center;
      gap: 1.5rem;
      box-shadow: 0 4px 20px rgba(0,0,0,0.4);
    }
    .node-dot {
      width: 52px; height: 52px;
      border-radius: 50%;
      background: rgba(255,255,255,0.15);
      display: flex; align-items: center; justify-content: center;
      font-size: 1.6rem;
      flex-shrink: 0;
    }
    .node-card h2 { font-size: 1.3rem; color: #fff; margin-bottom: 0.25rem; }
    .node-card p  { font-size: 0.9rem; color: rgba(255,255,255,0.75); }

    /* ---- HERO SECTION ---- */
    .hero {
      background: var(--surface);
      border-radius: 12px;
      padding: 2rem;
      margin-bottom: 2rem;
      border: 1px solid rgba(255,255,255,0.06);
    }
    .hero h1 { font-size: 1.6rem; margin-bottom: 0.75rem; color: #fff; }
    .hero p  { color: var(--muted); line-height: 1.7; }

    /* ---- GRID ---- */
    .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1.25rem; margin-bottom: 2rem; }

    .card {
      background: var(--surface);
      border-radius: 10px;
      padding: 1.25rem 1.5rem;
      border: 1px solid rgba(255,255,255,0.06);
    }
    .card-title {
      font-size: 0.7rem;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      color: var(--muted);
      margin-bottom: 0.5rem;
    }
    .card-value {
      font-size: 1.1rem;
      font-weight: 600;
      color: var(--text);
      word-break: break-word;
    }
    .card-value.green { color: var(--green); }
    .card-value.yellow { color: var(--yellow); }

    /* ---- CLUSTER TABLE ---- */
    .cluster-section { margin-bottom: 2rem; }
    .cluster-section h3 {
      font-size: 1rem;
      margin-bottom: 1rem;
      color: var(--text);
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }
    table { width: 100%; border-collapse: collapse; font-size: 0.88rem; }
    th {
      text-align: left;
      padding: 0.6rem 0.9rem;
      background: var(--surface2);
      color: var(--muted);
      font-weight: 600;
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.08em;
    }
    td { padding: 0.6rem 0.9rem; border-bottom: 1px solid rgba(255,255,255,0.04); }
    tr:last-child td { border-bottom: none; }
    tr:hover td { background: rgba(255,255,255,0.02); }
    .dot { display: inline-block; width:8px; height:8px; border-radius:50%; margin-right:6px; }
    .dot.leader { background: var(--green); }
    .dot.server { background: var(--primary); }
    .dot.client { background: var(--yellow); }

    /* ---- KV EXPLORER ---- */
    .kv-section { margin-bottom: 2rem; }
    .kv-section h3 { font-size: 1rem; margin-bottom: 1rem; color: var(--text); }
    .kv-row {
      display: flex;
      gap: 0.5rem;
      padding: 0.5rem 0.75rem;
      border-radius: 6px;
      font-size: 0.82rem;
      font-family: monospace;
      margin-bottom: 0.3rem;
      background: var(--surface);
      border: 1px solid rgba(255,255,255,0.04);
    }
    .kv-key   { color: var(--primary); flex: 0 0 auto; min-width: 220px; word-break: break-all; }
    .kv-sep   { color: var(--muted); }
    .kv-val   { color: var(--green); word-break: break-word; }

    /* ---- HOW TO UPDATE ---- */
    .howto {
      background: var(--surface2);
      border-radius: 10px;
      padding: 1.5rem;
      margin-bottom: 2rem;
      border: 1px solid rgba(255,255,255,0.06);
    }
    .howto h3 { margin-bottom: 1rem; }
    .howto pre {
      background: rgba(0,0,0,0.4);
      border-radius: 6px;
      padding: 0.75rem 1rem;
      font-size: 0.8rem;
      overflow-x: auto;
      color: var(--green);
      margin-bottom: 0.5rem;
    }
    .howto p { color: var(--muted); font-size: 0.88rem; margin-top: 0.5rem; }

    footer {
      background: var(--surface);
      text-align: center;
      padding: 1rem;
      color: var(--muted);
      font-size: 0.8rem;
      border-top: 1px solid rgba(255,255,255,0.05);
    }
  </style>
</head>
<body>

<!-- ====================== HEADER ====================== -->
<header>
  <div class="logo">HashiCorp <span>Consul</span></div>
  <div class="badge">{{ $env }} · v{{ $version }}</div>
</header>

{{ if eq $maintenance "true" }}
<div class="maintenance-bar">⚠️  Maintenance Mode Active — set nginx/features/maintenance_mode=false to disable</div>
{{ end }}

{{ if $banner }}
<div class="banner">{{ $banner }}</div>
{{ end }}

<main>

  <!-- ====================== NODE CARD ====================== -->
  <div class="node-card">
    <div class="node-dot">🖥️</div>
    <div>
      <h2>{{ $nodeName }}</h2>
      <p>{{ $nodeMsg }}</p>
    </div>
  </div>

  <!-- ====================== HERO ====================== -->
  <div class="hero">
    <h1>{{ $heroHeading }}</h1>
    <p>{{ $heroBody }}</p>
  </div>

  <!-- ====================== CONFIG GRID ====================== -->
  <div class="grid">
    <div class="card">
      <div class="card-title">Site Title</div>
      <div class="card-value">{{ $title }}</div>
    </div>
    <div class="card">
      <div class="card-title">Company / Lab</div>
      <div class="card-value">{{ $company }}</div>
    </div>
    <div class="card">
      <div class="card-title">Environment</div>
      <div class="card-value yellow">{{ $env }}</div>
    </div>
    <div class="card">
      <div class="card-title">Version</div>
      <div class="card-value">{{ $version }}</div>
    </div>
    <div class="card">
      <div class="card-title">This Node</div>
      <div class="card-value green">{{ $nodeName }}</div>
    </div>
    <div class="card">
      <div class="card-title">Listening Port</div>
      <div class="card-value">:{{ $nodePort }}</div>
    </div>
  </div>

  <!-- ====================== CLUSTER INFO ====================== -->
  {{ if eq $showCluster "true" }}
  <div class="cluster-section">
    <h3>🔗 Consul Cluster Members</h3>
    <table>
      <thead>
        <tr>
          <th>Role</th>
          <th>Node</th>
          <th>Address</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        {{/* nodes() returns *dependency.Node — fields: Node, Address, Datacenter, TaggedAddresses, Meta */}}
        {{ range nodes }}
        <tr>
          <td>
            {{ if regexMatch "consul-server" .Node }}
              <span class="dot server"></span>Server
            {{ else if regexMatch "consul-client" .Node }}
              <span class="dot client"></span>Client
            {{ else }}
              <span class="dot"></span>—
            {{ end }}
          </td>
          <td>{{ .Node }}</td>
          <td>{{ .Address }}</td>
          <td><span style="color:var(--green)">●</span> Up</td>
        </tr>
        {{ end }}
      </tbody>
    </table>
  </div>
  {{ end }}

  <!-- ====================== KV EXPLORER ====================== -->
  {{ if eq (keyOrDefault "nginx/features/show_kv_explorer" "true") "true" }}
  <div class="kv-section">
    <h3>🗄️ Live KV Store Values <small style="color:var(--muted);font-size:0.75rem">(auto-refreshed by consul-template)</small></h3>
    <div class="kv-row"><span class="kv-key">nginx/config/site_title</span><span class="kv-sep">=</span><span class="kv-val">{{ $title }}</span></div>
    <div class="kv-row"><span class="kv-key">nginx/config/company_name</span><span class="kv-sep">=</span><span class="kv-val">{{ $company }}</span></div>
    <div class="kv-row"><span class="kv-key">nginx/config/environment</span><span class="kv-sep">=</span><span class="kv-val">{{ $env }}</span></div>
    <div class="kv-row"><span class="kv-key">nginx/config/version</span><span class="kv-sep">=</span><span class="kv-val">{{ $version }}</span></div>
    <div class="kv-row"><span class="kv-key">nginx/config/primary_color</span><span class="kv-sep">=</span><span class="kv-val">{{ $color }}</span></div>
    <div class="kv-row"><span class="kv-key">nginx/nodes/{{ $nodeName }}/message</span><span class="kv-sep">=</span><span class="kv-val">{{ $nodeMsg }}</span></div>
    <div class="kv-row"><span class="kv-key">nginx/features/maintenance_mode</span><span class="kv-sep">=</span><span class="kv-val">{{ $maintenance }}</span></div>
    <div class="kv-row"><span class="kv-key">nginx/features/banner_message</span><span class="kv-sep">=</span><span class="kv-val">{{ $banner }}</span></div>
    <div class="kv-row"><span class="kv-key">nginx/content/hero_heading</span><span class="kv-sep">=</span><span class="kv-val">{{ $heroHeading }}</span></div>
  </div>
  {{ end }}

  <!-- ====================== HOW TO UPDATE ====================== -->
  <div class="howto">
    <h3>🛠️ How to update this page</h3>
    <p>Change any KV key using the Consul CLI or the UI — pages update automatically within ~5 seconds.</p>
    <pre>
# Change the site title on ALL nodes simultaneously
consul kv put nginx/config/site_title "My Custom Title"

# Change only this node's message
consul kv put nginx/nodes/{{ $nodeName }}/message "New message for {{ $nodeName }}"

# Switch primary color (hex value)
consul kv put nginx/config/primary_color "#e63946"

# Enable maintenance mode
consul kv put nginx/features/maintenance_mode true

# Update the announcement banner
consul kv put nginx/features/banner_message "🚀 Deployment in progress..."
    </pre>
    <p>Consul UI: <a href="http://localhost:8500/ui/dc1/kv" style="color:var(--primary)">http://localhost:8500/ui/dc1/kv</a></p>
  </div>

</main>

<footer>{{ $footer }} &nbsp;|&nbsp; Rendered at {{ timestamp }} &nbsp;|&nbsp; Node: {{ $nodeName }}</footer>

</body>
</html>
