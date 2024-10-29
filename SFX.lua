--[[
Minimal SFX script for DaVinci Resolve
Appends an audio clip to the timeline at the current timecode
Usage: wscript "path/to/Fu.vbs" "path/to/script/SFX.lua" <audio_clip_name> <track_index>
]]--

function setup()
    fusion = Fusion()
    project = fusion:GetResolve():GetProjectManager():GetCurrentProject()
    if not project then return end

    return {
        project = project,
        media_pool = project:GetMediaPool(),
        timeline = project:GetCurrentTimeline(),
        fps = project:GetCurrentTimeline():GetSetting("timelineFrameRate")
    }
end

function tc_to_frames(timecode, fps)
    h, m, s, f = timecode:match("(%d+):(%d+):(%d+):(%d+)")
    return fps * (h * 3600 + m * 60 + s) + f
end

-- This recursive function searches for a clip by name in the media pool
-- Bad approach. See SFX_full.lua for a better way.
function find_clip(folder, clip_name)
    for _, clip in ipairs(folder:GetClipList()) do
        if clip:GetName() == clip_name then
            return clip
        end
    end
    
    for _, sub_folder in ipairs(folder:GetSubFolders()) do
        clip = find_clip(sub_folder, clip_name)
        if clip then return clip end
    end
end

function add_clip_to_timeline(clip, track_index, timeline, fps)
    return {{
        mediaPoolItem = clip,
        startFrame = 0,
        endFrame = tc_to_frames(clip:GetClipProperty("Duration"), fps),
        trackIndex = track_index,
        recordFrame = tc_to_frames(timeline:GetCurrentTimecode(), fps)
    }}
end

function main(clip_name, track_index)
    env = setup()
    if not env or not env.timeline then return end
    
    env.media_pool:SetCurrentFolder(env.media_pool:GetRootFolder())
    env.media_pool:RefreshFolders()
    
    track_count = env.timeline:GetTrackCount("audio")
    track_index = math.min(track_index, track_count)
    
    clip = find_clip(env.media_pool:GetRootFolder(), clip_name)
    if clip then
        env.media_pool:AppendToTimeline(
            add_clip_to_timeline(clip, track_index, env.timeline, env.fps)
        )
    end
end

if arg[1] then
    main(arg[1], tonumber(arg[2]) or 1)
end
